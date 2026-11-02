#!/bin/bash
# Merge config/config.json and recursively copy the other managed Gemini files.
# Managed settings win; other target settings are preserved. Objects are merged
# recursively, arrays are replaced.
set -e

GEMINI_PATH="$HOME/.config/gemini"
INSTALL_PATH="$HOME/.gemini"

[ -d "$GEMINI_PATH" ] || exit 0

merge_config() {
    local source="$GEMINI_PATH/config/config.json"
    local target="$INSTALL_PATH/config/config.json"
    local tmp

    [ -f "$source" ] || return 0
    if [ ! -s "$target" ]; then
        install -m 600 "$source" "$target"
        return 0
    fi

    tmp="$(mktemp "$target.XXXXXX")"
    trap 'rm -f "$tmp"' EXIT

    if command -v jq >/dev/null 2>&1; then
        jq -s '.[0] * .[1]' "$target" "$source" >"$tmp"
    elif command -v python3 >/dev/null 2>&1; then
        python3 -I - "$target" "$source" >"$tmp" <<'PY'
import json, sys

def merge(a, b):
    if isinstance(a, dict) and isinstance(b, dict):
        out = dict(a)
        for k, v in b.items():
            out[k] = merge(a[k], v) if k in a else v
        return out
    return b

with open(sys.argv[1]) as f:
    target = json.load(f)
with open(sys.argv[2]) as f:
    source = json.load(f)
json.dump(merge(target, source), sys.stdout, indent=2, ensure_ascii=False)
print()
PY
    else
        echo "Neither jq nor python3 found; skipping merge of $source into $target" >&2
        rm -f "$tmp"
        trap - EXIT
        return 0
    fi

    chmod 600 "$tmp"
    mv "$tmp" "$target"
    trap - EXIT
}

ensure_directory() {
    local source_dir="$1"
    local target_dir="$2"

    if [ -L "$target_dir" ]; then
        if [ "$target_dir" -ef "$source_dir" ]; then
            unlink "$target_dir"
        fi
    fi
    mkdir -p "$target_dir"
}

ensure_directory "$GEMINI_PATH" "$INSTALL_PATH"

while IFS= read -r -d '' source_dir; do
    relative_dir="${source_dir#"$GEMINI_PATH"/}"
    ensure_directory "$source_dir" "$INSTALL_PATH/$relative_dir"
done < <(find "$GEMINI_PATH" -mindepth 1 -type d -print0)

merge_config

while IFS= read -r -d '' source_path; do
    [ -d "$source_path" ] && continue
    relative_file="${source_path#"$GEMINI_PATH"/}"
    [ "$relative_file" = config/config.json ] && continue
    target_path="$INSTALL_PATH/$relative_file"
    if [ -d "$target_path" ]; then
        printf 'Cannot replace directory with file: %s\n' "$target_path" >&2
        exit 1
    fi
    # Remove existing links so copying never writes through to their source.
    rm -f "$target_path"
    cp -L "$source_path" "$target_path"
done < <(find "$GEMINI_PATH" \( -type f -o -type l \) -print0)
