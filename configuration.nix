{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      google-antigravity = prev.callPackage (
        (builtins.fetchTarball {
          url = "https://github.com/jacopone/antigravity-nix/archive/refs/heads/master.tar.gz";
        }) + "/package.nix"
      ) {};
    })
  ];

  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "25.11";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };

    pulse.enable = true;
    jack.enable = true;
  };

  services.pipewire.wireplumber.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  services.blueman.enable = true;

  services.dbus.enable = true;
  services.openssh.enable = true;
  programs.dconf.enable = true;

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
    };
  };

  services.libinput.enable = true;

  services.logind.settings.Login = {
    IdleAction = "ignore";
    IdleActionSec = 0;
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

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  programs.nm-applet.enable = true;

  # Waydroid networking
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "waydroid0" ];
    allowedUDPPorts = [
      67
      53
      5353
    ];
    allowedTCPPorts = [
      67
      53
      5353
    ];
  };

  time.timeZone = "America/Phoenix";
  i18n.defaultLocale = "en_US.UTF-8";

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  services.ollama.enable = true;

  programs.nix-ld.enable = true;

  virtualisation = {
    docker.enable = true;
    waydroid.enable = true;
  };

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

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
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

  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };

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
