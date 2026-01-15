
{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  programs.nm-applet.enable = true;

  # Waydroid networking
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "waydroid0" ];
    allowedUDPPorts = [
      67
      53
      5353
    ];
    allowedTCPPorts = [
      67
      53
      5353
    ];
  };
}
