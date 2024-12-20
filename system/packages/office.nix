{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    libreoffice
    obsidian


  ];
}