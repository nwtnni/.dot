{
  description = "Personal system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, home-manager, impermanence, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations."nwtnni-g16" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit impermanence; };
        inherit system;
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.nwtnni = import ./home.nix;
          }
        ];
      };

      devShells.${system}.default = pkgs.mkShell {
        name = ".dot";
        nativeBuildInputs = with pkgs; [
          lua-language-server
          taplo
        ];
      };
    };
}
