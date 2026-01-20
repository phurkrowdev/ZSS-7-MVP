# Security settings
{ config, lib, pkgs, ... }:

{
  # Real-time kit for audio
  security.rtkit.enable = true;

  # Sudo configuration
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;  # Convenience for single-user workstation
  };
}
