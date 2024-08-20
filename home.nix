{ config, pkgs, ... }:

{
  imports = [
    # Import nix files from the user folder:
    ./user/sh.nix
  ];
  
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
        # Konfiguriert git, um SSH-URLs anstelle von HTTPS-URLs zu verwenden:
        url."ssh://git@github.com/".insteadOf = "https://github.com/";
        url."ssh://git@gitlab.com/".insteadOf = "https://gitlab.com/";
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
        "python.defaultInterpreterPath" = "/run/current-system/sw/bin/python";
      };
          
    };

    fzf.enable = true;

    firefox = {
      enable = true;
    };

    };

    programs.go = {
      enable = true;
      # extraPath = "/some/path"; # Falls du einen speziellen Go-Pfad brauchst
    };

    programs.ssh = {
      enable = true;
      extraConfig = ''
        Host github.com
        Hostname github.com
        User git

        Host gitlab.com
        Hostname gitlab.com
        User git

        Host avd-power
        Hostname 195.160.172.25
        User power
        IdentityFile ~/.ssh/cccb-power

      Host avd.club.berlin.ccc.de avd
        IdentityFile ~/.ssh/cccb-projekte
        # should be 195.160.172.24||avd.berlin.ccc.de| but doesn_t work
        # Hostname avd.club.berlin.ccc.de
        Hostname 195.160.172.24
        # Hostname 194.29.233.27
        # Hostname 172.23.42.106
        # Hostname 2001:678:560:42::24
        User murmeldin
        #User root
        ControlMaster yes
        ControlPath /tmp/ssh_control_%C
        LocalForward 8042 127.0.0.1:8042
        LocalForward 6006 127.0.0.1:6006
        LocalForward 9000 127.0.0.1:7860
        LocalForward 11434 127.0.0.1:1143

      Host nas-home
        Hostname fz6galkcgq4jhexn.myfritz.net
        User nas
        IdentityFile ~/.ssh/id_rsa.pub
        Port 11256
        LocalForward 8123 127.0.0.1:8123

      Host pc-home
        Hostname fz6galkcgq4jhexn.myfritz.net
        User murmeldin
        Port 11247
      Host pve-ubuntu
        Hostname 192.168.178.71
        User ubuntu-server
        Port 22

      Host ubuntu-vm
        Hostname krugs.duckdns.org
        User ubuntu-vm
        Port 11255

      Host ubuntu-vm.local
              Hostname 192.168.178.86
              User ubuntu-vm
              Port 22
        IdentityFile ~/.ssh/github-bananenbroetchen

      Host nobody-git
              HostName 217.115.15.84
              User git
              IdentityFile ~/.ssh/plenum-bot-cccb
      '';
    };
}
