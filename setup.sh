#!/usr/bin/env bash

LOWERCASE_HOSTNAME=$(hostname -s | awk '{print tolower($0)}')
OS=$(uname -s)

if grep -q 'NAME=NixOS' /etc/os-release 2>/dev/null; then
    echo "Detected NixOS. Rebuilding system configuration..."
    sudo nixos-rebuild switch --flake .#$LOWERCASE_HOSTNAME
elif [ "$OS" = "Darwin" ]; then
    echo "Detected macOS. Running nix-darwin..."
    nix run nix-darwin -- switch --flake .#$LOWERCASE_HOSTNAME
else
    echo "Running home-manager..."
    nix run home-manager -- --flake .#$(whoami)@$LOWERCASE_HOSTNAME switch
fi
