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
        my-upgrade = "sudo bnixos-rebuild switch --upgrade --flake .";
        my-flake-update = "sudo nix flake update";
        my-pull = "git -C ~/Repos/nixos-configuration pull --rebase";
        my-test = "sudo nixos-rebuild test";
        my-direnvallow = "echo \"use nix\" > .envrc && direnv allow";
        my-ip4 = "ip addr show | grep 192";
        my-folder-size-analyzer = "du -shx ./* | sort -h";
        my-borg-backup = "sudo /home/murmeldin/.dotfiles/borg_backup.sh";
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