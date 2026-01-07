{
  description = "ZSS-7 MVP Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        devShells = {
          # Default shell - minimal tools
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              curl
              jq
              ripgrep
            ];
          };

          # ZSS-7 Development Shell
          zazu = pkgs.mkShell {
            buildInputs = with pkgs; [
              # Python
              python311
              python311Packages.pip
              python311Packages.requests
              
              # Dev tools
              poetry
              ruff
              black
              
              # Optional: for future expansions
              # docker
              # docker-compose
              # postgresql_16
              # redis
            ];

            shellHook = ''
              echo ""
              echo "╔════════════════════════════════════════════╗"
              echo "║  🪶 ZSS-7 ZAZU SHELL ACTIVATED             ║"
              echo "╠════════════════════════════════════════════╣"
              echo "║  Python: $(python3 --version | cut -d' ' -f2)                          ║"
              echo "║  Session: GENESIS-001                      ║"
              echo "╚════════════════════════════════════════════╝"
              echo ""
            '';
          };
        };
      }
    );
}
