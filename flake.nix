{
  description = "Nixos config flake";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      stablePkgs = import nixpkgs-stable { inherit system; };
      hmLib = home-manager.lib;
    in
    {
      nixosConfigurations.miracunix = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
        ];
      };

      homeConfigurations = {
        murmeldin = hmLib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [
            ./home.nix
          ];
        };
      };
    };
}
