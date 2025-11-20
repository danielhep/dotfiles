# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Nix flakes-based dotfiles repository that manages system configurations across multiple platforms (macOS, NixOS, and Linux) using Nix-darwin, Home Manager, and NixOS. The configuration supports both personal and work environments with modular structure.

## Common Commands

### System Configuration Management

**Rebuild the current system configuration (auto-detects OS):**
```bash
./setup.sh
```

**Manual system rebuilds:**
```bash
# macOS (nix-darwin)
sudo nix run nix-darwin -- switch --flake .#<hostname>

# NixOS
sudo nixos-rebuild switch --flake .#<hostname>

# Standalone home-manager
nix run home-manager -- --flake .#<username>@<hostname> switch
```

**Testing changes:**
```bash
# Test without applying (dry run)
sudo nix run nix-darwin -- build --flake .#<hostname>

# Home-manager test
nix run home-manager -- --flake .#<username>@<hostname> build
```

**Nix flake management:**
```bash
# Update flake inputs
nix flake update

# Check flake
nix flake check

# Show flake metadata
nix flake metadata
```

## Architecture

### Key Files

- **`flake.nix`**: Main entry point defining all configurations and inputs
- **`setup.sh`**: Universal rebuild script that auto-detects the current system
- **`darwin/`**: nix-darwin system configurations for macOS
- **`home-manager/`**: Home Manager user configurations
- **`shared/`**: Shared packages and configurations across systems
- **`overlays/`**: Nix overlays for custom packages

### Configuration Targets

**Darwin configurations:**
- `daniels-mbp`: Personal macOS setup (aarch64-darwin, user: danielhep)
- `arcadis-mac-ch2wkxtjgj`: Work macOS setup (aarch64-darwin, user: daniel.heppner)

**NixOS configurations:**
- `nixos-personal`: Personal Linux setup (x86_64-linux, user: danielhep)

**Home Manager configurations:**
- `danielhep@daniels-mbp`: Standalone macOS home config
- `danielhep@personal-linux`: Standalone Linux home config

### Module Structure

**Base configuration pattern:**
- `home-manager/home.nix`: Base home-manager configuration with shared packages
- `home-manager/macos.nix`: macOS-specific home configuration (extends base)
- `home-manager/linux.nix`: Linux-specific home configuration
- `home-manager/work.nix`: Work-specific additions (imports extra packages)

**Program modules in `home-manager/programs/`:**
- `fish/`: Shell configuration
- `git.nix`: Git settings
- `vscode.nix`: VSCode configuration

### Key Features

- **Multi-platform support**: Single repo manages macOS, NixOS, and Linux
- **Environment separation**: Personal vs work configurations
- **Modular design**: Shared base configs with platform-specific extensions
- **Flake-based**: Reproducible builds with locked dependencies
- **Touch ID sudo**: Enabled on macOS configurations
- **Custom macOS defaults**: Keyboard, dock, trackpad settings configured

## Development Workflow

1. Make configuration changes
2. Test with `nix flake check`
3. Apply changes using `./setup.sh` or platform-specific commands
4. Commit changes to track configuration evolution

The system uses Nix flakes for reproducibility and supports both system-wide (nix-darwin/NixOS) and user-level (home-manager) configuration management.