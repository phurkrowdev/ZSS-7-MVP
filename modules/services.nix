
{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.pipewire = {
    enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };

    pulse.enable = true;
    jack.enable = true;
  };

  services.pipewire.wireplumber.enable = true;

  services.blueman.enable = true;

  services.dbus.enable = true;
  services.openssh.enable = true;
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

  services.ollama.enable = true;

  services.syncthing = {
    enable = true;
    user = "korvengo";
    dataDir = "/home/korvengo/.syncthing";
    configDir = "/home/korvengo/.config/syncthing";
    openDefaultPorts = true;
  };

  virtualisation = {
    docker.enable = true;
    waydroid.enable = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };
}
