# Development tools and environments
{ config, lib, pkgs, ... }:

{
  # ══════════════════════════════════════════════════════════════════
  # DIRENV
  # Auto-load environment when entering project directories
  # ══════════════════════════════════════════════════════════════════
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;  # Caches nix shells for faster loading
  };

  # ══════════════════════════════════════════════════════════════════
  # ZED EDITOR
  # Configured to work with local LLMs via Ollama
  #
  # To use with local models:
  # 1. Pull a model: ollama pull codellama
  # 2. Configure Zed's assistant to use http://localhost:11434
  # ══════════════════════════════════════════════════════════════════
  # Zed is included in pkgs/core.nix (zed-editor)
  # Ollama service is enabled in modules/services/default.nix
}
