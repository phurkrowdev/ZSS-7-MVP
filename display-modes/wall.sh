#!/usr/bin/env bash
# WALL MODE
# DP-2 + HDMI mirrored, desk monitor off
# Rebind Bluetooth audio if present (PipeWire-safe)

xrandr \
  --output DVI-D-0 --off \
  --output DP-2    --mode 1920x1080 --pos 0x0 --primary \
  --output HDMI-0  --mode 1920x1080 --same-as DP-2

# Give PipeWire a moment to rebuild the graph
sleep 1

# If a Bluetooth sink exists, make it default
BT_SINK=$(pactl list short sinks | awk '/bluez/ {print $2; exit}')
if [ -n "$BT_SINK" ]; then
  pactl set-default-sink "$BT_SINK"
fi

