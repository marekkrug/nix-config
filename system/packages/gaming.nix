{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    prismlauncher # for minecraft
    mindustry
    moonlight-qt
    xclicker
  ];

  programs = {
    steam.enable = true;
  };
}