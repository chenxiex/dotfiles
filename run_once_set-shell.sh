#!/bin/bash
set -e

if command -v zsh >/dev/null 2>&1; then
	sudo usermod -s "$(command -v zsh)" "$USER"
fi