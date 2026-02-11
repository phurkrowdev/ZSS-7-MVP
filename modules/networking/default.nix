# Networking configuration
# Architecture:
#   - Mullvad WireGuard: IP transport only (no DNS)
#   - NextDNS: Authoritative DNS via DNS-over-TLS (profile 468839)
#   - Tailscale: Mesh VPN, does not override DNS
#   - systemd-resolved: System DNS resolver, uses NextDNS upstream via DoT
{ config, lib, pkgs, ... }:

{
  # ══════════════════════════════════════════════════════════════════
  # NETWORK MANAGER
  # ══════════════════════════════════════════════════════════════════
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  programs.nm-applet.enable = true;

  # DNS handling: Disable NM's DNS management completely
  # systemd-resolved + NextDNS is authoritative
  networking.networkmanager.dns = lib.mkForce "none";

  # Ensure /etc/resolv.conf points to systemd-resolved stub
  # This forces ALL DNS through our NextDNS proxy
  environment.etc."resolv.conf".source =
    "/run/systemd/resolve/stub-resolv.conf";

  # ══════════════════════════════════════════════════════════════════
  # SYSTEMD-RESOLVED + NEXTDNS (DNS-over-TLS)
  # Profile: 468839
  # Direct DoT to NextDNS - no intermediate proxy needed
  # ══════════════════════════════════════════════════════════════════
  services.resolved = {
    enable = true;

    # Use new-style settings (NixOS 24.05+)
    settings = {
      Resolve = {
        # NextDNS servers with profile ID embedded in hostname
        # Format: <profile-id>.dns.nextdns.io
        DNS = [
          "45.90.28.0#468839.dns.nextdns.io"
          "45.90.30.0#468839.dns.nextdns.io"
          "2a07:a8c0::#468839.dns.nextdns.io"
          "2a07:a8c1::#468839.dns.nextdns.io"
        ];

        # No fallback resolvers = no DNS leaks
        FallbackDNS = "";

        # DNSSEC validation
        DNSSEC = "allow-downgrade";

        # REQUIRE DNS-over-TLS (strict mode)
        DNSOverTLS = "yes";
      };
    };
  };

  # Global nameservers point to systemd-resolved stub
  networking.nameservers = [ "127.0.0.53" ];

  # ══════════════════════════════════════════════════════════════════
  # FIREWALL
  # Includes Waydroid networking support
  # ══════════════════════════════════════════════════════════════════
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "waydroid0" ];
    allowedUDPPorts = [
      67    # DHCP
      53    # DNS (local only, NextDNS proxy)
      5353  # mDNS
    ];
    allowedTCPPorts = [
      67    # DHCP
      53    # DNS (local only, NextDNS proxy)
      5353  # mDNS
    ];
  };
}
