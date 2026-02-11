# System services
{ config, lib, pkgs, ... }:

{
  # ══════════════════════════════════════════════════════════════════
  # PRIVACY / VPN
  # ══════════════════════════════════════════════════════════════════
  services.mullvad.enable = true;
  # ══════════════════════════════════════════════════════════════════
  # AUDIO (PipeWire stack)
  # ══════════════════════════════════════════════════════════════════
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

  # ══════════════════════════════════════════════════════════════════
  # BLUETOOTH
  # ══════════════════════════════════════════════════════════════════
  services.blueman.enable = true;

  # ══════════════════════════════════════════════════════════════════
  # CORE SERVICES
  # ══════════════════════════════════════════════════════════════════
  services.dbus.enable = true;
  services.openssh.enable = true;

  # ══════════════════════════════════════════════════════════════════
  # OLLAMA (Local LLM inference)
  # Used with Zed editor for local AI assistance
  # ══════════════════════════════════════════════════════════════════
  services.ollama.enable = true;

  # ══════════════════════════════════════════════════════════════════
  # SYNCTHING (File sync)
  # ══════════════════════════════════════════════════════════════════
  services.syncthing = {
    enable = true;
    user = "korvengo";
    dataDir = "/home/korvengo/.syncthing";
    configDir = "/home/korvengo/.config/syncthing";
    openDefaultPorts = true;
  };

  # ══════════════════════════════════════════════════════════════════
  # GAMING
  # ══════════════════════════════════════════════════════════════════
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  # ══════════════════════════════════════════════════════════════════
  # FIREFOX (with PWA support)
  # ══════════════════════════════════════════════════════════════════
  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };
}
