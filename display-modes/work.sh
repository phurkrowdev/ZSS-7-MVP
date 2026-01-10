#!/usr/bin/env bash
# WORK MODE
# Desk monitor primary, mirrored wall above-right
xrandr \
  --output DVI-D-0 --mode 1920x1080 --pos 0x1080 --primary \
  --output DP-2    --mode 1920x1080 --pos 1920x0 \
  --output HDMI-0  --mode 1920x1080 --same-as DP-2

