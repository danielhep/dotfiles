{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix-darwin
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    mac-app-util.url = "github:hraban/mac-app-util";

    nix-colors.url = "github:misterio77/nix-colors";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";

    nixgl.url = "github:nix-community/nixGL";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      mac-app-util,
      determinate,
      nixgl,
      ...
    }@inputs:
    let
      # Define the overlay
      overlays = final: prev: {
        # vscodium = nixpkgs-unstable.legacyPackages.${prev.system}.vscodium;
        # aider-chat = nixpkgs-unstable.legacyPackages.${prev.system}.aider-chat;
        # signal-desktop = nixpkgs-unstable.legacyPackages.${prev.system}.signal-desktop;
        # vscode-extensions = nixpkgs-unstable.legacyPackages.${prev.system}.vscode-extensions;
      };
      # Function to apply overlay
      pkgsForSystem = system: import nixpkgs {
        inherit system;
        overlays = [  overlays nixgl.overlay ];
        config = { allowUnfree = true; };  # Set allowUnfree here
      };
      mkDarwinConfig =
        { system, username, homeModules ? [ ], sharedHomeModules ? [ ] }:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit inputs username system;
            pkgs = pkgsForSystem system;
          };
          modules = [
            ./darwin
            mac-app-util.darwinModules.default
            home-manager.darwinModules.home-manager
            {
              nixpkgs.pkgs = pkgsForSystem system;
              home-manager.sharedModules = [ mac-app-util.homeManagerModules.default ] ++ sharedHomeModules;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = {
                imports = [ ./home-manager/macos.nix ] ++ homeModules;
              };
              home-manager.extraSpecialArgs = {
                inherit system;
              };
            }
          ];
        };
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        nixos-personal = nixpkgs.lib.nixosSystem {
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
        arcadis-mac-ch2wkxtjgj = mkDarwinConfig {
          system = "aarch64-darwin";
          username = "daniel.heppner";
          homeModules = [ ./home-manager/work.nix ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#configurationName'
      homeConfigurations = {
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
          pkgs = pkgsForSystem "x86_64-linux";
          extraSpecialArgs = {
            inherit inputs;
            inherit nixgl;
            system = "x86_64-linux";
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
