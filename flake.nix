{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      unstablePkgs = import nixpkgs-unstable { inherit system; };
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
