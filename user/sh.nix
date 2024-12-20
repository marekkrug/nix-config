{ config, pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        # my own things:
        my-update = "cd ~/.dotfiles/ && git pull && git push && sudo nixos-rebuild switch --flake .";
        my-home-update = "cd ~/.dotfiles/ && git pull && git push && home-manager switch --flake .";
        cd-dotfiles = "cd ~/.dotfiles/";
        my-upgrade = "cd ~/.dotfiles/ && git pull && git push && sudo nix flake update && sudo nixos-rebuild switch --upgrade --flake .";
        my-boot-upgrade = "cd ~/.dotfiles/ && git pull && git push && sudo nix flake update && sudo nixos-rebuild boot --upgrade --flake .";
        my-flake-upgrade = "sudo nix flake update";
        my-pull = "git -C ~/Repos/nixos-configuration pull --rebase";
        #my-test = "sudo nixos-rebuild test";
        my-direnvallow = "echo \"use nix\" > .envrc && direnv allow";
        my-ip4 = "ip addr show | grep 192";
        my-folder-size-analyzer = "du -shx ./* | sort -h";
        my-borg-backup = "sudo /home/murmeldin/.dotfiles/borg_backup.sh";
        my-storage-saver = "nix-store --optimise";
        gs = "git status";
        # defaults:
        ll = "ls -l";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "thefuck" ];
        theme = "agnoster";
      };

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

    };
  };
}