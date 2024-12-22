{ config, pkgs, ... }:

{
  # Aktiviere den udisks2-Daemon für Hot-Plugging
  services.udisks2.enable = true;

  # Aktiviere udev-Regeln
  services.udev.enable = true;

  # LUKS-Verschlüsselung konfigurieren
  boot.initrd.luks.devices."cold_backup" = {
    device = "/dev/disk/by-uuid/0ccab6e5-ed3a-4cf1-9522-6b79825822aa";
    allowDiscards = false;  # Aktiviere TRIM falls SSD (optional)
    preLVM = false;
  };

  # Füge die Mountpoint-Konfiguration hinzu
  fileSystems."/mnt/cold_backup" = {
    device = "/dev/mapper/cold_backup";  # Pfad zum entschlüsselten LUKS-Device
    fsType = "auto";
    
    # Optionen für sicheres Hot-Plugging
    options = [
      "nofail"
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

  # Füge den Nutzer zur storage-Gruppe hinzu für Zugriff
  users.users.murmeldin = {
    extraGroups = [ "storage" "disk" ];  # 'disk' Gruppe für LUKS-Zugriff
  };

  # Erlaube nicht-root Benutzern das Entschlüsseln
  security.polkit.enable = true;
}
