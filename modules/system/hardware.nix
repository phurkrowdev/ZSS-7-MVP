# Hardware configuration (non-host-specific)
{ config, lib, pkgs, ... }:

{
  # ══════════════════════════════════════════════════════════════════
  # BLUETOOTH
  # ══════════════════════════════════════════════════════════════════
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  # ══════════════════════════════════════════════════════════════════
  # GRAPHICS
  # ══════════════════════════════════════════════════════════════════
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # For Steam/gaming
  };

  # ══════════════════════════════════════════════════════════════════
  # NVIDIA
  # ══════════════════════════════════════════════════════════════════
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    open = false;  # Use proprietary driver
  };

  # ══════════════════════════════════════════════════════════════════
  # MEMORY MANAGEMENT
  # ══════════════════════════════════════════════════════════════════
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };
}
