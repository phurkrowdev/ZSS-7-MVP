# User: korvengo
{ config, lib, pkgs, ... }:

{
  users.users.korvengo = {
    isNormalUser = true;
    description = "Korvengo";
    extraGroups = [
      "wheel"          # Sudo access
      "docker"         # Docker without sudo
      "networkmanager" # Network management
      "audio"          # Audio device access
      "video"          # Video device access
    ];
  };

  # Session environment (NixOS-native, no bashrc drift)
  environment.sessionVariables = {
    PATH = "$HOME/.local/bin:$PATH";
  };
}
