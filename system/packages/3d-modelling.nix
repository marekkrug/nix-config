{ config, pkgs, ...}:
{

  environment.systemPackages = with pkgs; [
    freecad
    blender
    kicad

  ];

}
