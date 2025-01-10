{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    prismlauncher # for minecraft
    mindustry
    moonlight-qt
  ];

  programs = {
    steam.enable = true;
  };
}