
{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.kdeconnect.enable = true;
  programs.dconf.enable = true;

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
    };
  };

  services.libinput.enable = true;

  services.logind.settings.Login = {
    IdleAction = "ignore";
    IdleActionSec = 0;
  };

  fonts.packages = with pkgs; [
    dejavu_fonts
    noto-fonts
    inter
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
}
