#!/usr/bin/env bash

hyprctl dispatch togglefloating
hyprctl dispatch centerwindow
hyprctl dispatch moveactive exact 0 0
hyprctl dispatch resizeactive exact 100% 100%