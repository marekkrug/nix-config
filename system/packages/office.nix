{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    libreoffice
    obsidian
    resilio-sync

  ];
}