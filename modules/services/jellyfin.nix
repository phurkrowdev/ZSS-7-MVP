# modules/services/jellyfin.nix
# Jellyfin media server configuration
{ config, lib, pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    openFirewall = true; # opens TCP 8096 (HTTP) and 8920 (HTTPS)
  };

  # Grant jellyfin user access to media devices for hardware transcoding
  users.users.jellyfin.extraGroups = [ "audio" "video" "render" ];
}
