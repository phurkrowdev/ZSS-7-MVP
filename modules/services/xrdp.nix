# modules/services/xrdp.nix
# Remote desktop access via Tailscale
{ config, lib, pkgs, ... }:

{
  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-x11";
  };

  # Allow RDP only over Tailscale
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 3389 ];
}
