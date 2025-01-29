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
    ncpu # folder size analyzer
  ];

  programs = {
    zsh.enable = true;
	};
}