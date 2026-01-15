
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

  services.ollama.enable = true;

  services.syncthing = {
    enable = true;
    user = "korvengo";
    dataDir = "/home/korvengo/.syncthing";
    configDir = "/home/korvengo/.config/syncthing";
    openDefaultPorts = true;
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
