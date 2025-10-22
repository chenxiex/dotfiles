#!/bin/bash
set -e

# 检查 zsh 是否在 PATH 中
if command -v zsh >/dev/null 2>&1; then
    zsh_path="$(command -v zsh)"

    # 如果当前默认 shell 不是 zsh，则修改
    if [ "$SHELL" != "$zsh_path" ]; then
        echo "Setting default shell to: $zsh_path"
        chsh -s "$zsh_path"
	fi
fi