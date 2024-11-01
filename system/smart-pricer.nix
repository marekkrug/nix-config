{ config, pkgs, ... }:

{
    # Prevent shutdown to hang
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=30s
  '';

    # Enable docker service
  # See https://nixos.wiki/wiki/Docker
  virtualisation.docker.enable = true;
  users.users.murmeldin.extraGroups = [ "docker" ];
  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.autoPrune.dates = "weekly";
  virtualisation.docker.autoPrune.flags = [ "--all" ];
  # Autoprune bedeutet also, dass Docker regelmäßig automatisch
  # auf deinem System aufgeräumt wird, indem ungenutzte oder
  # unnötige Docker-Ressourcen entfernt werden. Dies hilft,
  # Speicherplatz zu sparen und das System sauber zu halten.

    # Extended sudo timeout
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=30
  '';

    # Provide /bin/bash
  system.activationScripts.binbash = {
    deps = [ "binsh" "usrbinenv" ];
    supportsDryActivation = true;

    text = ''
      echo '#!/bin/sh' > /bin/bash
      echo '/usr/bin/env bash $@' >> /bin/bash

      chmod +x /bin/bash
    '';
  };

    # Open ports in the firewall.
  networking.firewall = {
    enable = true;

    trustedInterfaces = [ "docker0" ];
    
    allowedTCPPorts = [ 80 443 ];
    #allowedUDPPortRanges = [
    #  { from = 4000; to = 4007; }
    #  { from = 8000; to = 8010; }
    #];
  };

    environment.systemPackages = with pkgs; [
      slack
      gitkraken
      go
      gopls
      python3
      python313
      #python3.packages.pip
      # aus ubuntu config
      bison
      jetbrains.goland
      jetbrains.pycharm-community
      git
      git-lfs
      google-chrome
      #selenium-manager

    ];

  environment.variables = {
    GOPRIVATE = "github.com/smartpricer/*";
  };
  
}

