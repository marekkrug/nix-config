{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager?nixos-24.11";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system;  config.allowUnfree = true; };
      specialArgs = { inherit system; inherit inputs; inherit pkgs;};       # <- passing inputs to the attribute set for NixOS (optional)
      hmLib = home-manager.lib;
    in
    {
      nixosConfigurations = {
        miracunix = nixpkgs.lib.nixosSystem {
          inherit specialArgs;           # <- this will make inputs available anywhere in the NixOS configuration
          modules = [
            ./configuration-miracunix.nix
            ./hw-config-miracunix.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.murmeldin = import ./home-murmeldin.nix;
            }
          ];
        };
        obelnix = nixpkgs.lib.nixosSystem {
          inherit specialArgs;           # <- this will make inputs available anywhere in the NixOS configuration
          modules = [
            ./configuration-obelnix.nix
            ./hw-config-obelnix.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.murmeldin = import ./home-murmeldin.nix;
            }
          ];
        };
        # homeConfigurations = {
        #   murmeldin = hmLib.homeManagerConfiguration {
        #     pkgs = pkgs;
        #     modules = [
        #       ./home.nix
        #     ];
        #   };
        # };

      };
    };
}
