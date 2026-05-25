#!/bin/bash

egpu_path="/dev/dri/nvidia-egpu"

export HYPR_GAMEMODE=1

choose_fallback() {
    echo "Warning: egpu or display not found!"
    echo "1) Continue and start Hyprland"
    echo "2) Switch to tty2"

    while true; do
        read -r -p "Choose an option [1/2]: " choice
        case "$choice" in
            1)
                start-hyprland
                chvt 2 && \
                    exit
                ;;
            2)
                chvt 2 && \
                    exit
                ;;
            *)
                echo "Invalid option. Please choose 1 or 2."
                ;;
        esac
    done
}

shopt -s nullglob
dp_paths=( /sys/class/drm/*-DP-5 )
shopt -u nullglob

if [[ -e "$egpu_path" && ${#dp_paths[@]} -gt 0 ]]; then
    toggle-gpu-display.sh nvidia detect && \
        start-hyprland
    toggle-gpu-display.sh nvidia off && \
        pause.sh && \
        chvt 2 && \
        exit
else
    choose_fallback
fi
