#!/usr/bin/env bash

echo "$(date): Skript wurde getriggert" >> /var/log/dispatcher.log

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Überprüfen, ob der Backup-Server erreichbar ist (egal ob per WLAN oder VPN)
ping -c 1 ubuntu-vm &> /dev/null
if [ $? -ne 0 ]; then
    echo "Backup-Server nicht erreichbar. Backup wird nicht gestartet."
    exit 0
fi

# Verschlüsselte Backup-Partition mounten
if ! mountpoint -q /mnt/backup; then
    echo "Mounting /dev/mapper/backup_crypt to /mnt/backup"
    sudo mount /dev/mapper/backup_crypt /mnt/backup
    if [ $? -ne 0 ]; then
        echo "Fehler beim Mounten der Backup-Partition. Skript abgebrochen."
        exit 1
    fi
fi

# Mounten des 5TB NAS-Verzeichnisses auf ubuntu-vm
# ssh ubuntu-vm "sudo mount /dev/sdb1 /mnt/5tbHDD"
# if [ $? -ne 0 ]; then
#     echo "Fehler beim Mounten des 5TB NAS-Verzeichnisses. Skript abgebrochen."
#     exit 1
# fi

# Setting this, so the repo does not need to be given on the commandline:
export BORG_REPO='/mnt/backup/borg'
export BORG_RSH='ssh -i /home/murmeldin/.ssh/id_ed25519_backup'

# Setting this, so you won't be asked for your repository passphrase:
export BORG_PASSPHRASE=Vegan-King-Doctrine-Imagines9-Drained

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

# Backup the /mnt/5tbHDD directory from the remote server via SSH
borg create                         \
    --verbose                       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression none              \
    --exclude-caches                \
                                    \
    ::'{hostname}-{now}'            \
    ssh://ubuntu-vm.local:/mnt/5tbHDD

backup_exit=$?

info "Pruning repository"

borg prune                          \
    --list                          \
    --glob-archives '{hostname}-*'  \
    --show-rc                       \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6               \

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 1 ]; then
    info "Backup and/or Prune finished with a warning"
fi

if [ ${global_exit} -gt 1 ]; then
    info "Backup and/or Prune finished with an error"
fi

exit ${global_exit}
