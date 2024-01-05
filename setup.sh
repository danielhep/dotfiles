LOWERCASE_HOSTNAME=$(hostname -s | awk '{print tolower($0)}')
nix run home-manager -- --flake .#$(whoami)@$LOWERCASE_HOSTNAME switch