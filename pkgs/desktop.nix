{ pkgs }:

with pkgs;
[
  xterm
  weston
  dmenu

  (waveterm.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ makeWrapper ];

    postInstall = (old.postInstall or "") + ''
      wrapProgram $out/bin/waveterm \
        --add-flags "--enable-gpu-rasterization \
        --canvas-oop-rasterization \
        --use-gl=desktop \
        --force-dark-mode \
        --disable-features=WebGPU,UseSkiaRenderer"
    '';
  }))

  flameshot
  thunar
  networkmanagerapplet
  blueman
  xclip
  wl-clipboard
  xdg-utils
  proton-vpn-cli
  protonvpn-gui
  wireguard-tools
  networkmanager-openvpn
  telegram-desktop
  signal-desktop
  discord

]
