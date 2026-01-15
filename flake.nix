{
  description = "ZSS-7 MVP Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      flake = false;
    };
    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, antigravity-nix, claude-desktop }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    flake-utils.lib.eachDefaultSystem (system: {
      devShells = {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [ git curl jq ripgrep ];
        };
        zazu = pkgs.mkShell {
          buildInputs = with pkgs; [
            python311 python311Packages.pip python311Packages.requests
            poetry ruff black
          ];
          shellHook = ''
            echo "Zazu Shell Activated"
          '';
        };
      };
    }) // {
      # System Configuration
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit antigravity-nix; };
        modules = [
          ./configuration.nix
          # Add Claude Desktop to system packages
          ({ pkgs, ... }: {
            environment.systemPackages = [
              claude-desktop.packages.${system}.default
            ];
          })
        ];
      };
    };
}
