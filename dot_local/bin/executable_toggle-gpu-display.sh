#!/bin/bash

# 定义 GPU 显示器状态切换函数
set_gpu_display_status() {
    local driver=$1
    local action=$2  # 接收参数: off 或 detect
    local max_retries=${3:-3}
    local retry=0

    while true; do
        local found=false

        # 1. 寻找显卡编号
        for card_path in /sys/class/drm/card[0-9]; do
            if grep -q "DRIVER=$driver" "$card_path/device/uevent" 2>/dev/null; then
                local card_name=$(basename "$card_path")

                # 2. 遍历该显卡下所有的 DP 接口
                for status_file in /sys/class/drm/"$card_name"-DP-*/status; do
                    if [ -f "$status_file" ]; then
                        echo "Setting $status_file to $action"
                        echo "$action" | sudo tee "$status_file" > /dev/null
                        found=true
                    fi
                done
            fi
        done

        if [ "$found" = true ]; then
            return 0
        fi

        if [ "$retry" -ge "$max_retries" ]; then
            echo "Warning: working $driver GPU display not found."
            return 1
        fi

        retry=$((retry + 1))
        echo "Warning: working $driver GPU display not found. Retrying in 1 second... ($retry/$max_retries)"
        sleep 1
    done
}

set_gpu_display_status "$1" "$2" "$3"
