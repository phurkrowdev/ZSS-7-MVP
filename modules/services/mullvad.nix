# modules/services/mullvad.nix
# Mullvad WireGuard VPN with agenix secret management
#
# ROLE: IP transport ONLY (no DNS)
# DNS is handled by NextDNS via systemd-resolved
#
# USAGE:
#   services.mullvad.enable = true;
#
# VERIFICATION:
#   sudo wg show
#   curl https://am.i.mullvad.net/connected
#
# SECRET MANAGEMENT:
#   Edit secret: cd ~/nixos-config/secrets && agenix -e mullvad.conf.age
#   Key rotation: Update secret content, then rebuild
#
# NOTE: mullvad.conf.age must NOT contain a DNS= line

{ config, pkgs, lib, ... }:

let
  # Path where agenix decrypts the secret at runtime
  wgConfig = config.age.secrets."mullvad.conf".path;
in
{
  options.services.mullvad = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Mullvad WireGuard VPN with agenix secret management";
    };
  };

  config = lib.mkIf config.services.mullvad.enable {
    # ═══════════════════════════════════════════════════════════════════════
    # AGENIX IDENTITY CONFIGURATION
    # ═══════════════════════════════════════════════════════════════════════

    age.identityPaths = [ "/etc/age/key.txt" ];

    # ═══════════════════════════════════════════════════════════════════════
    # AGENIX SECRET DECLARATION
    # ═══════════════════════════════════════════════════════════════════════

    age.secrets."mullvad.conf" = {
      # Source: encrypted file in repo
      file = ../../secrets/mullvad.conf.age;

      # Name sets the symlink name in /run/agenix/
      # Result: /run/agenix/mullvad.conf (wg-quick requires .conf extension)

      # Owner and permissions
      owner = "root";
      group = "root";
      mode = "0600";
    };

    # ═══════════════════════════════════════════════════════════════════════
    # WIREGUARD CONFIGURATION
    # ═══════════════════════════════════════════════════════════════════════

    networking.wireguard.enable = true;

    environment.systemPackages = [ pkgs.wireguard-tools ];

    # ═══════════════════════════════════════════════════════════════════════
    # SYSTEMD SERVICE
    # ═══════════════════════════════════════════════════════════════════════

    systemd.services.mullvad = {
      description = "Mullvad WireGuard VPN";
      documentation = [ "https://mullvad.net/help/wireguard-and-mullvad-vpn/" ];

      # Start after network is online
      # Note: agenix secrets are decrypted during NixOS activation (before systemd)
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;

        ExecStart = "${pkgs.wireguard-tools}/bin/wg-quick up ${wgConfig}";
        ExecStop = "${pkgs.wireguard-tools}/bin/wg-quick down ${wgConfig}";

        # Restart on failure
        Restart = "on-failure";
        RestartSec = "5s";
      };

      # Verify secret exists before starting
      preStart = ''
        if [ ! -f "${wgConfig}" ]; then
          echo "ERROR: Mullvad secret not decrypted at ${wgConfig}"
          echo "Ensure agenix is configured and mullvad.conf.age exists"
          exit 1
        fi
      '';
    };
  };
}
