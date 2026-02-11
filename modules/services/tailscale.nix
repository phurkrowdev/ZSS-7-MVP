# modules/services/tailscale.nix
# Tailscale mesh VPN for remote access
# DNS: Managed by NextDNS, NOT Tailscale (--accept-dns=false)
{ config, lib, pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    # Do not accept DNS from Tailscale - NextDNS is authoritative
    extraUpFlags = [ "--accept-dns=false" ];
  };

  # Open firewall for Tailscale
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
