{
  description = "Blacklight Terminal - NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Secret management with age encryption
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Google Earth alternative
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      flake = false;
    };

    # Claude AI tools
    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, agenix, antigravity-nix, claude-desktop, claude-code }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    # ════════════════════════════════════════════════════════════════════
    # DEVELOPMENT SHELLS
    # Usage: nix develop .#<shell-name>
    # ════════════════════════════════════════════════════════════════════
    flake-utils.lib.eachDefaultSystem (system: {
      devShells = {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [ git curl jq ripgrep gh ];
        };
        
        zazu = pkgs.mkShell {
          buildInputs = [
            (pkgs.python311.withPackages (ps: [
             ps.pyyaml
             ps.requests
           ]))
           pkgs.ruff
           pkgs.black
           pkgs.stdenv.cc.cc.lib
         ];

         shellHook = ''
           export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"
           echo "🪶 Zazu Shell Activated"
         '';
        };
      };
    }) // {
      # ══════════════════════════════════════════════════════════════════
      # SYSTEM CONFIGURATION
      # Rebuild with: sudo nixos-rebuild switch --flake .#nixos
      # ══════════════════════════════════════════════════════════════════
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        
        # Pass external inputs to configuration modules
        specialArgs = {
          inherit antigravity-nix agenix;
        };

        modules = [
          # Main host configuration
          ./hosts/nixos/configuration.nix

          # ────────────────────────────────────────────────────────────────
          # AGENIX SECRET MANAGEMENT
          # Secrets are decrypted at boot and placed in /run/agenix/
          # CLI config is in ./secrets/secrets.nix (used by `agenix` command)
          # ────────────────────────────────────────────────────────────────
          agenix.nixosModules.default

          # ────────────────────────────────────────────────────────────────
          # CLAUDE AI INTEGRATION
          # - Claude Desktop: GUI chat interface
          # - Claude Code: CLI coding assistant (requires Pro subscription)
          # ────────────────────────────────────────────────────────────────
          ({ pkgs, ... }: {
            # Apply claude-code overlay to make it available as pkgs.claude-code
            nixpkgs.overlays = [ claude-code.overlays.default ];
            
            environment.systemPackages = [
              claude-desktop.packages.${system}.default
              pkgs.claude-code
              agenix.packages.${system}.default  # CLI for encrypting secrets
            ];
          })
        ];
      };
    };
}
