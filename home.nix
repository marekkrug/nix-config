{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "murmeldin";
  home.homeDirectory = "/home/murmeldin";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # the Home Manager release notes for a list of state version
  # changes in each release.  # You can update Home Manager without changing this value. See

  home.stateVersion = "24.05";
  programs = {
     # Let Home Manager install and manage itself.
    home-manager.enable = true;
    
    git = {
      enable = true;
      userEmail = "git-mail@marekkrug.de";
      userName = "murmeldin";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      enableUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        ms-python.python
        kamadorueda.alejandra
        editorconfig.editorconfig
        yzhang.markdown-all-in-one
        redhat.vscode-yaml
        pkief.material-icon-theme
        mhutchie.git-graph
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        llvm-vs-code-extensions.vscode-clangd
        mkhl.direnv
        vadimcn.vscode-lldb
        ms-dotnettools.csharp
        jnoortheen.nix-ide
        golang.go
        ms-python.python
      ];
      userSettings = {
        "diffEditor.diffAlgorithm"= "advanced";
        "editor.fontFamily"= "'Fira Code', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontLigatures"= true;
        "editor.minimap.autohide"= true;
        "explorer.excludeGitIgnore"= true;
        "extensions.autoCheckUpdates"= false;
        "extensions.autoUpdate"= false;
        "git.autofetch" = true;
        "git.enableSmartCommit" = true;
        "markdown.extension.tableFormatter.normalizeIndentation"= true;
        "markdown.extension.toc.orderedList"= false;
        "redhat.telemetry.enabled"= false;
        "rust-analyzer.checkOnSave.command"= "clippy";
        "telemetry.telemetryLevel"= "off";
        "update.mode"= "none";
        "files.autoSave" = "afterDelay";
        "workbench.enableExperiments"= false;
        "workbench.iconTheme"= "material-icon-theme";
        "workbench.startupEditor"= "readme";
        "\[makefile\]" = {
          "editor.detectIndentation" = false;
          "editor.insertSpaces" = false;
        };
      };
          
    };

    fzf.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        # my own things:
        my-update = "sudo nixos-rebuild switch --flake /home/murmeldin/.dotfiles/";
        my-home-update = "home-manager switch --flake /home/murmeldin/.dotfiles/";
        my-upgrade = "sudo nixos-rebuild switch --upgrade --flake /home/murmeldin/.dotfiles/";
        my-pull = "git -C ~/Repos/nixos-configuration pull --rebase";
        my-test = "sudo nixos-rebuild test";
        my-direnvallow = "echo \"use nix\" > .envrc && direnv allow";
        my-ip4 = "ip addr show | grep 192";
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
