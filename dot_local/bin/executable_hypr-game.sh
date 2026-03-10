#!/bin/bash

egpu_path="/dev/dri/nvidia-egpu"

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
    echo "Warning: egpu or display not found!"
    pause.sh && \
        chvt 2 && \
        exit
fi
