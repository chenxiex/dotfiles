#!/usr/bin/bash

flatpak kill com.heroicgameslauncher.hgl
command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit