{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix-darwin
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv/latest";
    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";
    mac-app-util.url = "github:hraban/mac-app-util";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
  let
    mkDarwinConfig = { system, username }: darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs username; };
      modules = [
        ./darwin
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = import ./home-manager/macos.nix;
        }
      ];
    };
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      borgbrr = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        # > Our main nixos configuration file <
        modules = [ ./nixos/borgbrr.nix ];
      };
    };

    # Nix-darwin configuration entrypoint
    # Available through 'darwin-rebuild switch --flake .#your-hostname'
    darwinConfigurations = {
      daniels-mbp = mkDarwinConfig {
        system = "aarch64-darwin";
        username = "danielhep";
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#configurationName'
    homeConfigurations = {
      "daniel.heppner@nse092852" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          ./home-manager/macos.nix
          {
            home = {
              username = "daniel.heppner";
              homeDirectory = "/Users/daniel.heppner";
            };
          }
        ];
      };
      "danielhep@daniels-mbp" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          ./home-manager/macos.nix
          {
            home = {
              username = "danielhep";
              homeDirectory = "/Users/danielhep";
            };
          }
        ];
      };
      "danielhep@personal-linux" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          ./home-manager/linux.nix
          {
            home = {
              username = "danielhep";
              homeDirectory = "/home/danielhep";
            };
          }
        ];
      };
    };
  };
}
