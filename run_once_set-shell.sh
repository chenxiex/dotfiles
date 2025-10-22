#!/bin/bash
set -e

if command -v zsh >/dev/null 2>&1; then
    if [ "$SHELL" != "$zsh_path" ]; then
        echo "Setting default shell to: $zsh_path"
        usermod -s "$(command -v zsh)" "$USER"
	fi
fi