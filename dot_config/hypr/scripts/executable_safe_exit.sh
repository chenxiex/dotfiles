#!/usr/bin/bash

flatpak kill com.heroicgameslauncher.hgl
hyprctl keyword monitor DP-5,disable
sleep 10
command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit