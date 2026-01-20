# Boot configuration
{ config, lib, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = [
    "rtl8821au"
    "binder_linux"  # Required for Waydroid
  ];
  
  boot.extraModulePackages = with config.boot.kernelPackages; [ 
    rtl8821au 
  ];

  # Required for some containerization features
  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
}
