# Desktop environment configuration
# Plasma 6 + i3 + multi-monitor setup
{ config, lib, pkgs, ... }:

{
  # ══════════════════════════════════════════════════════════════════
  # DESKTOP PROGRAMS
  # ══════════════════════════════════════════════════════════════════
  programs.kdeconnect.enable = true;
  programs.dconf.enable = true;

  # ══════════════════════════════════════════════════════════════════
  # DISPLAY MANAGER & DESKTOP
  # ══════════════════════════════════════════════════════════════════
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  # ══════════════════════════════════════════════════════════════════
  # XSERVER & GRAPHICS
  # ══════════════════════════════════════════════════════════════════
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    # ────────────────────────────────────────────────────────────────
    # MULTI-MONITOR LAYOUT (left to right)
    # DVI-D-1: Dell 1920x1080 (left, vertically centered)
    # DP-3: Primary 2560x1440 @ 120Hz (center)
    # HDMI-A-5: LG 2560x1440 (right)
    # ────────────────────────────────────────────────────────────────
    xrandrHeads = [
      {
        output = "DVI-D-1";
        primary = false;
        monitorConfig = ''
          Option "Position" "0 360"
          Option "PreferredMode" "1920x1080"
        '';
      }
      {
        output = "DP-3";
        primary = true;
        monitorConfig = ''
          Option "Position" "1920 0"
          Option "PreferredMode" "2560x1440"
        '';
      }
      {
        output = "HDMI-A-5";
        primary = false;
        monitorConfig = ''
          Option "Position" "4480 0"
          Option "PreferredMode" "2560x1440"
        '';
      }
    ];

    # i3 window manager (available alongside Plasma)
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
    };
  };

  # ══════════════════════════════════════════════════════════════════
  # INPUT
  # ══════════════════════════════════════════════════════════════════
  services.libinput.enable = true;

  # ══════════════════════════════════════════════════════════════════
  # POWER MANAGEMENT
  # Disable idle actions (workstation always-on)
  # ══════════════════════════════════════════════════════════════════
  services.logind.settings.Login = {
    IdleAction = "ignore";
    IdleActionSec = 0;
  };

  # ══════════════════════════════════════════════════════════════════
  # FONTS
  # ══════════════════════════════════════════════════════════════════
  fonts.packages = with pkgs; [
    dejavu_fonts
    noto-fonts
    inter
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
}
