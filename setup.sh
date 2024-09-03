#!/usr/bin/env bash

LOWERCASE_HOSTNAME=$(hostname -s | awk '{print tolower($0)}')
OS=$(uname -s)

if [ "$OS" = "Darwin" ]; then
    echo "Detected macOS. Running nix-darwin..."
    nix run nix-darwin -- switch --flake .#$LOWERCASE_HOSTNAME
else
    echo "Running home-manager..."
    nix run home-manager -- --flake .#$(whoami)@$LOWERCASE_HOSTNAME switch
fi
