
{
  config,
  lib,
  pkgs,
  antigravity-nix,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      google-antigravity = prev.callPackage (antigravity-nix + "/package.nix") {};
    })
  ];

  imports = [
    ./hardware-configuration.nix
    ./modules/services.nix
    ./modules/networking.nix
  ];

  system.stateVersion = "25.11";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  security.rtkit.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    open = false;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = [
    "rtl8821au"
    "binder_linux"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ rtl8821au ];

  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = 1;

  time.timeZone = "America/Phoenix";
  i18n.defaultLocale = "en_US.UTF-8";

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  programs.nix-ld.enable = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  users.users.korvengo = {
    isNormalUser = true;
    description = "Korvengo";
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "audio"
      "video"
    ];
  };

  environment.systemPackages =
    (import ./pkgs/core.nix { inherit pkgs; })
    ++ (import ./pkgs/audio.nix { inherit pkgs; })
    ++ (import ./pkgs/desktop.nix { inherit pkgs; })
    ++ (import ./pkgs/browser.nix { inherit pkgs; })
    ++ (import ./pkgs/media.nix { inherit pkgs; })
    ++ (import ./pkgs/archive.nix { inherit pkgs; })
    ++ (import ./pkgs/extra.nix { inherit pkgs; });

  fonts.packages = with pkgs; [
    dejavu_fonts
    noto-fonts
    inter
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  xdg.mime.defaultApplications = {
    "video/mp4" = "vlc.desktop";
    "video/x-matroska" = "vlc.desktop";
    "video/webm" = "vlc.desktop";
    "video/quicktime" = "vlc.desktop";
    "video/x-msvideo" = "vlc.desktop";
    "audio/mpeg" = "vlc.desktop";
    "audio/flac" = "vlc.desktop";
    "audio/x-wav" = "vlc.desktop";
    "audio/ogg" = "vlc.desktop";
  };
}
