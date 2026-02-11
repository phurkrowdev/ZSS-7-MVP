#!/usr/bin/env bash
# setup-agenix.sh - Initialize agenix secrets for NixOS config
#
# Run this script once to:
# 1. Generate age public keys from your SSH keys
# 2. Update secrets.nix with the correct keys
# 3. Create the encrypted mullvad.conf.age secret

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECRETS_NIX="$SCRIPT_DIR/secrets.nix"

echo "═══════════════════════════════════════════════════════════════"
echo "  Agenix Setup for NixOS"
echo "═══════════════════════════════════════════════════════════════"
echo

# Check for ssh-to-age
if ! command -v ssh-to-age &> /dev/null; then
    echo "Installing ssh-to-age temporarily..."
    nix-shell -p ssh-to-age --run "$(realpath "$0")"
    exit 0
fi

echo "Step 1: Converting SSH keys to age format"
echo "─────────────────────────────────────────"

# User key
USER_SSH_KEY="$HOME/.ssh/id_ed25519.pub"
if [ -f "$USER_SSH_KEY" ]; then
    USER_AGE_KEY=$(ssh-to-age < "$USER_SSH_KEY")
    echo "User key (korvengo):"
    echo "  $USER_AGE_KEY"
else
    echo "WARNING: User SSH key not found at $USER_SSH_KEY"
    USER_AGE_KEY="age1_USER_KEY_NOT_FOUND"
fi

echo

# Host key
HOST_SSH_KEY="/etc/ssh/ssh_host_ed25519_key.pub"
if [ -f "$HOST_SSH_KEY" ]; then
    HOST_AGE_KEY=$(sudo ssh-to-age < "$HOST_SSH_KEY")
    echo "Host key (nixos):"
    echo "  $HOST_AGE_KEY"
else
    echo "WARNING: Host SSH key not found at $HOST_SSH_KEY"
    HOST_AGE_KEY="age1_HOST_KEY_NOT_FOUND"
fi

echo
echo "Step 2: Updating secrets.nix"
echo "────────────────────────────"

# Backup original
cp "$SECRETS_NIX" "$SECRETS_NIX.bak"

# Replace placeholder keys
sed -i "s|korvengo = \"age1x\+\";|korvengo = \"$USER_AGE_KEY\";|" "$SECRETS_NIX"
sed -i "s|nixos = \"age1x\+\";|nixos = \"$HOST_AGE_KEY\";|" "$SECRETS_NIX"

echo "Updated $SECRETS_NIX with your age keys"
echo "Backup saved to $SECRETS_NIX.bak"

echo
echo "Step 3: Create Mullvad secret"
echo "─────────────────────────────"
echo
echo "You now need to create the encrypted secret."
echo "Run the following command:"
echo
echo "  cd $SCRIPT_DIR && agenix -e mullvad.conf.age"
echo
echo "This will open your editor. Paste your Mullvad WireGuard config"
echo "(download from https://mullvad.net/account/#/wireguard-config)"
echo
echo "═══════════════════════════════════════════════════════════════"
echo "  Setup complete! Next steps:"
echo "═══════════════════════════════════════════════════════════════"
echo
echo "1. Create the secret:"
echo "   cd $SCRIPT_DIR && agenix -e mullvad.conf.age"
echo
echo "2. Rebuild NixOS:"
echo "   sudo nixos-rebuild switch --flake ~/nixos-config#nixos"
echo
echo "3. Verify VPN:"
echo "   sudo wg show"
echo "   curl https://am.i.mullvad.net/connected"
echo
