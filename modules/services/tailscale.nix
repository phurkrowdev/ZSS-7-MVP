# modules/services/tailscale.nix
# Tailscale mesh VPN for remote access
{ config, lib, pkgs, ... }:

{
  services.tailscale.enable = true;
  
  # Open firewall for Tailscale
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
