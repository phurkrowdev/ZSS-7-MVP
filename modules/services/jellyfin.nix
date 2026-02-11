# modules/services/jellyfin.nix
# Jellyfin media server configuration
{ config, lib, pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    openFirewall = false; # Don't expose to LAN
  };

  # Allow Jellyfin only over Tailscale
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 8096 ];

  # Grant jellyfin user access to media devices for hardware transcoding
  users.users.jellyfin.extraGroups = [ "audio" "video" "render" ];
}
