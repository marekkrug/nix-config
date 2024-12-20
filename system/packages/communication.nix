{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [

    signal-desktop
    telegram-desktop
    element-desktop
    thunderbird
    discord

  ];
}