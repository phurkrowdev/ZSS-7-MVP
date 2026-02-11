{ pkgs }:

with pkgs;
[
  git
  gh
  curl
  wget
  nix-ld
  tree
  jq
  ripgrep
  fd
  htop
  direnv
  nix-direnv
  mesa-demos
  iw
  pciutils
  kitty
  neovim
  zed-editor    # Local LLM support via Ollama
  openssh
  sshfs
  xorg.xrandr
  papirus-icon-theme
  zenity
  android-tools
  wireguard-tools
  networkmanager
  networkmanagerapplet
]
