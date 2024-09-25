{ config, pkgs, ... }:

{
  services.networkmanager = {
    enable = true;
    dispatcherScripts = [
      {
        name = "auto-backup";
        source = pkgs.writeScript "auto-backup" ''
          #!/bin/sh
          SSID=$(iwgetid -r)
          HOME_SSID="FRITZ!Box 7490_DJME"

          if [ "$SSID" = "$HOME_SSID" ]; then
              # Starte dein Backup-Skript hier
              sudo /home/murmeldin/.dotfiles/borg_backup.sh
          fi
        '';
      }
    ];
  };
}
