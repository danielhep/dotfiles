{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix-darwin
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    mac-app-util.url = "github:hraban/mac-app-util";

    nix-colors.url = "github:misterio77/nix-colors";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      darwin,
      mac-app-util,
      determinate,
      ...
    }@inputs:
    let
      # Define the overlay
      vscodiumOverlay = final: prev: {
        vscodium = nixpkgs-unstable.legacyPackages.${prev.system}.vscodium;
      };
      # Function to apply overlay
      pkgsForSystem = system: import nixpkgs {
        inherit system;
        overlays = [ vscodiumOverlay ];
        config = { allowUnfree = true; };  # Set allowUnfree here
      };
      mkDarwinConfig =
        { system, username }:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit inputs username;
            pkgs = pkgsForSystem system;
          };
          modules = [
            ./darwin
            determinate.darwinModules.default
            mac-app-util.darwinModules.default
            home-manager.darwinModules.home-manager
            {
              nixpkgs.pkgs = pkgsForSystem system;
              home-manager.sharedModules = [ mac-app-util.homeManagerModules.default ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home-manager/macos.nix;
            }
          ];
        };
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        personal-nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.danielhep = import ./home-manager/linux.nix;
            }
          ];
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
          extraSpecialArgs = {
            inherit inputs;
          }; # Pass flake inputs to our config
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
          extraSpecialArgs = {
            inherit inputs;
          }; # Pass flake inputs to our config
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
          extraSpecialArgs = {
            inherit inputs;
          }; # Pass flake inputs to our config
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
