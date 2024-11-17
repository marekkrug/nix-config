{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    btop
    htop
    mission-center
    stress
    powertop
    nmap
    tree
    gparted
    nvme-cli
  ];
}