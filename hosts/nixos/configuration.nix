# Host: nixos (Blacklight Terminal)
# Primary workstation configuration
{ config, lib, pkgs, antigravity-nix, ... }:

{
  imports = [
    ./hardware-configuration.nix
    
    # Core system modules
    ../../modules/system/boot.nix
    ../../modules/system/nix-settings.nix
    ../../modules/system/hardware.nix
    ../../modules/system/virtualisation.nix
    
    # Security
    ../../modules/security/default.nix
    
    # User management
    ../../modules/users/korvengo.nix
    
    # Desktop environment
    ../../modules/desktop/default.nix
    
    # Networking & VPN
    ../../modules/networking/default.nix
    ../../modules/services/tailscale.nix
    ../../modules/services/mullvad.nix
    
    # Services
    ../../modules/services/default.nix
    
    # Development tools
    ../../modules/dev/default.nix

    # Jellyfin server
    ../../modules/services/jellyfin.nix

    # Remote desktop (Tailscale only)
    ../../modules/services/xrdp.nix
  ];

  # ══════════════════════════════════════════════════════════════════
  # HOST IDENTITY
  # ══════════════════════════════════════════════════════════════════
  networking.hostName = "nixos";
  system.stateVersion = "25.11";

  # ══════════════════════════════════════════════════════════════════
  # NIXPKGS CONFIGURATION
  # ══════════════════════════════════════════════════════════════════
  nixpkgs.config.allowUnfree = true;

  # Antigravity overlay (Google Earth alternative)
  nixpkgs.overlays = [
    (final: prev: {
      google-antigravity = prev.callPackage (antigravity-nix + "/package.nix") {};
    })
  ];

  # ══════════════════════════════════════════════════════════════════
  # SYSTEM PACKAGES
  # Organized imports from pkgs/ directory
  # ══════════════════════════════════════════════════════════════════
  environment.systemPackages =
    (import ../../pkgs/core.nix { inherit pkgs; })
    ++ (import ../../pkgs/audio.nix { inherit pkgs; })
    ++ (import ../../pkgs/desktop.nix { inherit pkgs; })
    ++ (import ../../pkgs/browser.nix { inherit pkgs; })
    ++ (import ../../pkgs/media.nix { inherit pkgs; })
    ++ (import ../../pkgs/archive.nix { inherit pkgs; })
    ++ (import ../../pkgs/extra.nix { inherit pkgs; });

  # ══════════════════════════════════════════════════════════════════
  # LOCALE & TIMEZONE
  # ══════════════════════════════════════════════════════════════════
  time.timeZone = "America/Phoenix";
  i18n.defaultLocale = "en_US.UTF-8";

  # ══════════════════════════════════════════════════════════════════
  # DEFAULT APPLICATIONS
  # ══════════════════════════════════════════════════════════════════
  xdg.mime.defaultApplications = {
    "video/mp4" = "vlc.desktop";
    "video/x-matroska" = "vlc.desktop";
    "video/webm" = "vlc.desktop";
    "video/quicktime" = "vlc.desktop";
    "video/x-msvideo" = "vlc.desktop";
    "audio/mpeg" = "vlc.desktop";
    "audio/flac" = "vlc.desktop";
    "audio/x-wav" = "vlc.desktop";
    "audio/ogg" = "vlc.desktop";
  };
}
