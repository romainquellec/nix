{
  description = "NixOS Flake configuration with Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... }@inputs:
    let
      sharedModules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";

            users.tks = import ./modules/home.nix;
          };
        }

        nix-flatpak.nixosModules.nix-flatpak
      ];
    in
    {
      nixosConfigurations.PCFix-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/PCFix-nixos/hardware-configuration.nix ./hosts/PCFix-nixos/config.nix ] ++ sharedModules;
      };

      nixosConfigurations.Laptop-TKS = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/Laptop-TKS/hardware-configuration.nix ./hosts/Laptop-TKS/config.nix ] ++ sharedModules;
      };
    };
}