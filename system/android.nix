{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    p7zip
    adb
    curl
    whiptail
    pv
    bc
    secure-delete
    zenity
  ];
}