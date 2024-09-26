{ config, pkgs, ... }:

{
  networking.networkmanager = {
    enable = false;
    dispatcherScripts = [
      {
        source = pkgs.writeScript "auto-backup" ''
          #!/bin/bash
          sleep 10
          SSID=$(/run/current-system/sw/bin/nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2)
          HOME_SSID="FRITZ\!Box 7490_DJME"

          if [ "$SSID" = "$HOME_SSID" ]; then
              # Starte dein Backup-Skript hier
              /run/wrappers/bin/sudo /home/murmeldin/.dotfiles/borg_backup.sh
          fi
        '';
        type = "basic";
      }
    ];
  };
    
  environment.systemPackages = with pkgs; [
    wirelesstools
    borgbackup
    networkmanager
  ];
}
