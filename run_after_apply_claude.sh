#!/bin/bash
# Merge settings.json and recursively link the other managed Claude files.
# Managed settings win; other target settings are preserved. Objects are merged
# recursively, arrays are replaced.
set -e

CLAUDE_PATH="$HOME/.config/claude"
INSTALL_PATH="$HOME/.claude"

[ -d "$CLAUDE_PATH" ] || exit 0

merge_settings() {
    local source="$CLAUDE_PATH/settings.json"
    local target="$INSTALL_PATH/settings.json"
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

relative_path() {
    perl -MCwd=abs_path -MFile::Basename=dirname,basename -MFile::Spec -e '
        my ($target, $base) = @ARGV;
        my $target_dir = abs_path(dirname($target)) // die "cannot resolve target dir: $target\n";
        my $base_dir = abs_path($base) // die "cannot resolve base dir: $base\n";
        print File::Spec->abs2rel(File::Spec->catfile($target_dir, basename($target)), $base_dir);
    ' "$1" "$2"
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

ensure_directory "$CLAUDE_PATH" "$INSTALL_PATH"
merge_settings

while IFS= read -r -d '' source_dir; do
    relative_dir="${source_dir#"$CLAUDE_PATH"/}"
    ensure_directory "$source_dir" "$INSTALL_PATH/$relative_dir"
done < <(find "$CLAUDE_PATH" -mindepth 1 -type d -print0)

while IFS= read -r -d '' source_path; do
    [ -d "$source_path" ] && continue
    relative_file="${source_path#"$CLAUDE_PATH"/}"
    [ "$relative_file" = settings.json ] && continue
    target_path="$INSTALL_PATH/$relative_file"
    if [ -d "$target_path" ]; then
        printf 'Cannot replace directory with file link: %s\n' "$target_path" >&2
        exit 1
    fi
    ln -sfn "$(relative_path "$source_path" "${target_path%/*}")" "$target_path"
done < <(find "$CLAUDE_PATH" \( -type f -o -type l \) -print0)
