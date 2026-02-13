#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

LOWERCASE_HOSTNAME=$(hostname -s | awk '{print tolower($0)}')
OS=$(uname -s)

has_nixos_target() {
    local target="$1"
    nix eval --raw "path:.#nixosConfigurations.\"${target}\".config.system.stateVersion" >/dev/null 2>&1
}

if grep -q 'NAME=NixOS' /etc/os-release 2>/dev/null; then
    echo "Detected NixOS. Rebuilding system configuration..."
    TARGET="$LOWERCASE_HOSTNAME"
    if ! has_nixos_target "$TARGET"; then
        TARGET="nixos"
    fi
    echo "Using NixOS flake target: $TARGET"
    sudo nixos-rebuild switch --flake "path:.#$TARGET"
elif [ "$OS" = "Darwin" ]; then
    echo "Detected macOS. Running nix-darwin..."
    sudo nix run nix-darwin -- switch --flake "path:.#$LOWERCASE_HOSTNAME"
else
    echo "Running home-manager..."
    nix run home-manager -- --flake "path:.#$(whoami)@$LOWERCASE_HOSTNAME" switch -b backup
fi
