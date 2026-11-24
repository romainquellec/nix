{
  description = "NixOS Flake configuration with Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # Repackage maintenu du .deb Linux officiel d'Anthropic (k3d3 n'est plus mis à jour)
    claude-desktop.url = "github:aaddrick/claude-desktop-debian";
    claude-desktop.inputs.nixpkgs.follows = "nixpkgs";

    # Claude Code mis à jour quotidiennement (nixpkgs 25.11 est figé sur une vieille version)
    claude-code.url = "github:sadjow/claude-code-nix";
    claude-code.inputs.nixpkgs.follows = "nixpkgs";
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
            extraSpecialArgs = { inherit inputs; };

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