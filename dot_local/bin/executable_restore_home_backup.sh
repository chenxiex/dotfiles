#!/usr/bin/env bash
set -euo pipefail

SRC_PREFIX="${HOME}_bak"
DST_PREFIX="${HOME}"
LIST_FILE="${HOME}/.config/restore.list"

RSYNC_OPTS=(
  -aHAX
  --relative
  --info=progress2
  --human-readable
)

if [[ ! -f "$LIST_FILE" ]]; then
  echo "❌ 白名单文件不存在: $LIST_FILE" >&2
  exit 1
fi

# 读取白名单到数组
mapfile -t PATHS < "$LIST_FILE"

for rel in "${PATHS[@]}"; do
  # 跳过空行和注释
  [[ -z "$rel" || "$rel" =~ ^[[:space:]]*# ]] && continue

  src="$SRC_PREFIX/$rel"

  if [[ ! -e "$src" ]]; then
    echo "⚠️  不存在，跳过: $src"
    continue
  fi

  echo "▶ 恢复: $rel"
  rsync "${RSYNC_OPTS[@]}" "$SRC_PREFIX/./$rel" "$DST_PREFIX/"
  echo "Deleting $src"
  rm -Ir "$src"
done
