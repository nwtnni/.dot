{
  description = "Personal system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, impermanence, ... }: {
    nixosConfigurations."nwtnni-g16" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit impermanence; };
      modules = [
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.users.nwtnni = import ./nix/home.nix;
        }
      ];
    };
  };
}
