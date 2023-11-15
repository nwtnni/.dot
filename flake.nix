{
  description = "Personal system configuration";

  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { nixpkgs, home-manager, impermanence, ... }: {
    nixosConfigurations."nwtnni-g16" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit impermanence; };
      modules = [
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nwtnni = import ./nix/home.nix;
        }
      ];
    };
  };
}
