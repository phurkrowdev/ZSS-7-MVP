# Virtualisation: Docker, Waydroid, etc.
{ config, lib, pkgs, ... }:

{
  virtualisation = {
    docker.enable = true;
    waydroid.enable = true;
  };
}
