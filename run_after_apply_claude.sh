#!/bin/bash
# Merge ~/.config/claude/settings.json (managed by chezmoi) into
# ~/.claude/settings.json. Keys from the managed file win; everything else in
# the target is preserved. Objects are merged recursively, arrays are replaced.
set -e

SOURCE="$HOME/.config/claude/settings.json"
TARGET="$HOME/.claude/settings.json"

[ -f "$SOURCE" ] || exit 0

mkdir -p "${TARGET%/*}"
if [ ! -s "$TARGET" ]; then
  install -m 600 "$SOURCE" "$TARGET"
  exit 0
fi

tmp="$(mktemp "$TARGET.XXXXXX")"
trap 'rm -f "$tmp"' EXIT

if command -v jq >/dev/null 2>&1; then
  jq -s '.[0] * .[1]' "$TARGET" "$SOURCE" >"$tmp"
elif command -v python3 >/dev/null 2>&1; then
  python3 -I - "$TARGET" "$SOURCE" >"$tmp" <<'PY'
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
  echo "Neither jq nor python3 found; skipping merge of $SOURCE into $TARGET" >&2
  exit 0
fi

chmod 600 "$tmp"
mv "$tmp" "$TARGET"
trap - EXIT
