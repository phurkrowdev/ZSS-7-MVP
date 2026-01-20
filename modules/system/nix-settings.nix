# Nix daemon and flake settings
{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable nix-ld for running unpatched binaries
  programs.nix-ld.enable = true;
}
