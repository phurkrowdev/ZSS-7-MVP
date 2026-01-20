{ pkgs }:

with pkgs;
[
  git
  curl
  wget
  nix-ld
  tree
  jq
  ripgrep
  fd
  htop
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
]
