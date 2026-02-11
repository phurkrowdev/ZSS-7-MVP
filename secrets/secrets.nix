# secrets/secrets.nix
# Agenix secret declarations
#
# This file declares which secrets exist and which keys can decrypt them.
# Secrets are encrypted with `age` and decrypted at boot time.
#
# ═══════════════════════════════════════════════════════════════════════════
# SETUP INSTRUCTIONS (one-time)
# ═══════════════════════════════════════════════════════════════════════════
#
# 1. Convert your SSH keys to age public keys:
#
#    # Install ssh-to-age temporarily
#    nix-shell -p ssh-to-age
#
#    # Convert user key
#    ssh-to-age < ~/.ssh/id_ed25519.pub
#
#    # Convert host key (for system decryption at boot)
#    sudo ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
#
# 2. Replace the placeholder age keys below with your actual keys
#
# 3. Encrypt your Mullvad config:
#
#    cd /home/korvengo/nixos-config/secrets
#    agenix -e mullvad.conf.age
#
#    This opens your $EDITOR. Paste your Mullvad WireGuard config and save.
#
# 4. To re-edit a secret later:
#
#    agenix -e mullvad.conf.age
#
# ═══════════════════════════════════════════════════════════════════════════

let
  # ─────────────────────────────────────────────────────────────────────────
  # USER KEYS
  # These allow you to encrypt/decrypt secrets from your user account
  # Generate with: ssh-to-age < ~/.ssh/id_ed25519.pub
  # ─────────────────────────────────────────────────────────────────────────

  # korvengo's age key (stored in ~/.config/age/keys.txt)
  korvengo = "age19ldsfrcjd0n5yqcdx5zrlm5lyvutn5pjzzuvy50pqldfurdwqe0s90ml4y";

  users = [ korvengo ];

  # ─────────────────────────────────────────────────────────────────────────
  # HOST KEYS
  # These allow the NixOS system to decrypt secrets at boot
  # Generate with: sudo ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
  # ─────────────────────────────────────────────────────────────────────────

  # nixos host key (ed25519)
  # SSH: ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIId6QH3T05IhQ+nblUnHYtuff5EDapUmtyNRi8hlmOK2
  nixos = "age1paumqvj2w04mnz95y8sdn3fgzq6kd3hc3gwmjmt07qcgt8rk8uhq7yxksn";

  systems = [ nixos ];

  # All keys that should be able to decrypt secrets
  allKeys = users ++ systems;

in
{
  # ═══════════════════════════════════════════════════════════════════════════
  # SECRET DECLARATIONS
  # ═══════════════════════════════════════════════════════════════════════════

  # Mullvad WireGuard configuration
  # Contains: [Interface] and [Peer] sections with private key
  # Decrypt location: /run/agenix/mullvad.conf (at runtime)
  "mullvad.conf.age".publicKeys = allKeys;

  # ─────────────────────────────────────────────────────────────────────────
  # FUTURE SECRETS (uncomment as needed)
  # ─────────────────────────────────────────────────────────────────────────

  # NextDNS configuration (if you want to store profile ID as secret)
  # "nextdns.conf.age".publicKeys = allKeys;

  # Tailscale auth key (for headless setup)
  # "tailscale-authkey.age".publicKeys = allKeys;

  # Additional WireGuard peers
  # "wireguard-peer-home.conf.age".publicKeys = allKeys;
}
