{
  description = "Nixos config flake";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs?ref=nixos-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvchad4nix = {
      url = "github:NvChad/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system;  config.allowUnfree = true; };
      stablePkgs = import nixpkgs-stable { inherit system;  config.allowUnfree = true; };
      extraSpecialArgs = { inherit system; inherit inputs; };  # <- passing inputs to the attribute set for home-manager
      specialArgs = { inherit system; inherit inputs; };       # <- passing inputs to the attribute set for NixOS (optional)
      hmLib = home-manager.lib;
    in
    {
      nixosConfigurations = {
        miracunix = nixpkgs.lib.nixosSystem {
          inherit specialArgs;           # <- this will make inputs available anywhere in the NixOS configuration
          modules = [
            ./configuration.nix
            ./hardware-configuration.nix
          ];
        };
      };

      homeConfigurations = {
        murmeldin = hmLib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = extraSpecialArgs;
          modules = [
            ./home.nix
          ];
        };
      };
    };
}
