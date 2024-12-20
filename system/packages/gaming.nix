{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    prismlauncher # for minecraft

  ];

  programs = {
    steam.enable = true;
  };
}