{
  description = "Blacklight Terminal - NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    
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

  outputs = { self, nixpkgs, flake-utils, antigravity-nix, claude-desktop, claude-code }:
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
          buildInputs = with pkgs; [ git curl jq ripgrep ];
        };
        
        zazu = pkgs.mkShell {
          buildInputs = with pkgs; [
            python311 
            python311Packages.pip 
            python311Packages.requests
            poetry 
            ruff 
            black
          ];
          shellHook = ''
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
          inherit antigravity-nix; 
        };
        
        modules = [
          # Main host configuration
          ./hosts/nixos/configuration.nix
          
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
            ];
          })
        ];
      };
    };
}
