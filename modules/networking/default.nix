# Networking configuration
{ config, lib, pkgs, ... }:

{
  # ══════════════════════════════════════════════════════════════════
  # NETWORK MANAGER
  # ══════════════════════════════════════════════════════════════════
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  programs.nm-applet.enable = true;

  # ══════════════════════════════════════════════════════════════════
  # FIREWALL
  # Includes Waydroid networking support
  # ══════════════════════════════════════════════════════════════════
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "waydroid0" ];
    allowedUDPPorts = [
      67    # DHCP
      53    # DNS
      5353  # mDNS
    ];
    allowedTCPPorts = [
      67    # DHCP
      53    # DNS
      5353  # mDNS
    ];
  };
}
