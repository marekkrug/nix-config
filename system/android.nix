{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    p7zip
    android-tools
    curl
    pv
    bc
    zenity
    dialog
  ];
}