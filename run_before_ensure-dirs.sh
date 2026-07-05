#!/usr/bin/env bash
set -euo pipefail

dirs=(
  "$HOME/.codex"
)

for dir in "${dirs[@]}"; do
  if [ -d "$dir" ]; then
    # 真实目录，或指向目录的 symlink，都算存在
    continue
  fi

  if [ -L "$dir" ]; then
    echo "error: $dir is a broken symlink" >&2
    exit 1
  fi

  if [ -e "$dir" ]; then
    echo "error: $dir exists but is not a directory" >&2
    exit 1
  fi

  mkdir -p "$dir"
  echo "created: $dir"
done