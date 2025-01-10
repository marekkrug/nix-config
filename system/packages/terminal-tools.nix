{ config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    tldr
    thefuck
    nix-output-monitor
    neofetch
    pandoc
    yt-dlp
    tokei
  ];

  programs = {
    zsh.enable = true;
	};
}