# NixOS System Configuration – nixos

This repository contains the full declarative NixOS configuration
for the host `nixos`.

Entry point:
- flake.nix

Primary system module:
- configuration.nix (currently monolithic)

Hardware definition:
- hardware-configuration.nix (auto-generated)

Package lists:
- pkgs/*.nix (logical groupings)

This structure is intentionally preserved as-is while understanding
and documentation are stabilized. Refactors will be incremental.
