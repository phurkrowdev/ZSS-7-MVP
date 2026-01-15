{ pkgs }:

with pkgs;
[
  google-antigravity
  steamcmd

  (freetube.overrideAttrs (_: {
    version = "0.23.12";
    __intentionallyOverridingVersion = true;
  }))

  android-studio
  obsidian
  qbittorrent
]
