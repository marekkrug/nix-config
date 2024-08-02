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
      ];
      userSettings = {
        "git.autofetch" = true;
        "update.mode" = "none";
        "editor.fontFamily" = "'Fira Code', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontLigatures" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnSaveMode" = "modificationsIfAvailable";
        "editor.minimap.autohide" = true;
        "diffEditor.diffAlgorithm" = "advanced";
        "explorer.excludeGitIgnore" = true;
        "markdown.extension.tableFormatter.normalizeIndentation" = true;
        "markdown.extension.toc.orderedList" = false;
        "telemetry.telemetryLevel" = "off";
        "redhat.telemetry.enabled" = false;
        "workbench.startupEditor" = "readme";
        "workbench.enableExperiments" = false;
        "workbench.iconTheme" = "material-icon-theme";
        "rust-analyzer.checkOnSave.command" = "clippy";
        "extensions.autoUpdate" = false;
        "extensions.autoCheckUpdates" = false;
        "\[makefile\]" = {
          "editor.insertSpaces" = false;
          "editor.detectIndentation" = false;
        };
      };
    };

    fzf.enable = true;

    zsh = {
      initExtra = ''
        eval "$(direnv hook zsh)";
        export PATH=$PATH:/home/vinzenz/.cargo/bin
      '';

    shellAliases = {
      my-apply = "sudo nixos-rebuild boot";
      my-switch = "sudo nixos-rebuild switch --flake /home/murmeldin/.dotfiles/";
      my-update = "sudo nixos-rebuild boot --upgrade";
      my-pull = "git -C ~/Repos/nixos-configuration pull --rebase";
      my-fmt = "alejandra .";
      my-test = "sudo nixos-rebuild test";
      my-direnvallow = "echo \"use nix\" > .envrc && direnv allow";
      my-ip4 = "ip addr show | grep 192";
    };

    };

 
  };
}
