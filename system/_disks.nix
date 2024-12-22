{ config, pkgs, ... }:

{
  # Aktiviere den udisks2-Daemon für Hot-Plugging
  services.udisks2.enable = true;

  # Aktiviere udev-Regeln
  services.udev.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", KERNEL=="sd*", ENV{ID_FS_UUID}=="0ccab6e5-ed3a-4cf1-9522-6b79825822aa", RUN+="${pkgs.systemd}/bin/systemctl start cryptsetup-cold-backup"
  '';

  # Systemd Service für das Entschlüsseln und Mounten
  systemd.services."cryptsetup-cold-backup" = {
    description = "Open LUKS device cold_backup";
    path = [ pkgs.cryptsetup ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # Prüfe ob das Gerät vorhanden ist
      if [ -e /dev/disk/by-uuid/0ccab6e5-ed3a-4cf1-9522-6b79825822aa ]; then
        # Versuche LUKS Container zu öffnen, wenn nicht bereits offen
        if ! [ -e /dev/mapper/cold_backup ]; then
          cryptsetup open /dev/disk/by-uuid/0ccab6e5-ed3a-4cf1-9522-6b79825822aa cold_backup
        fi
      fi
    '';
  };

  # Füge die Mountpoint-Konfiguration hinzu
  fileSystems."/mnt/cold_backup" = {
    device = "/dev/mapper/cold_backup";
    fsType = "auto";
    options = [
      "nofail"
      "noauto"        # Wichtig: Verhindert Automount beim Boot
      "x-systemd.automount"
      "x-systemd.idle-timeout=1min"
      "x-systemd.device-timeout=5s"
      "noatime"
    ];
  };

  # Erstelle den Mount-Punkt mit korrekten Berechtigungen
  systemd.tmpfiles.rules = [
    "d /mnt/cold_backup 0755 root root -"
  ];

  # Erlaube nicht-root Benutzern das Entschlüsseln
  security.polkit.enable = true;

  # Optional: Füge den Nutzer zur storage-Gruppe hinzu für Zugriff
  users.users.murmeldin = {
    extraGroups = [ "storage" "disk" ];
  };
}