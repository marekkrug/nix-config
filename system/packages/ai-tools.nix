{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    ollama
    # upscayl
  ];
}