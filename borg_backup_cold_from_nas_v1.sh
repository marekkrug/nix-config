#!/usr/bin/env bash

echo "$(date): Skript wurde getriggert" >> /var/log/dispatcher.log

# Überprüfen, ob der Benutzer root ist
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Überprüfen, ob der Laptop erreichbar ist
ping -c 1 ubuntu-vm &> /dev/null
if [ $? -ne 0 ]; then
    echo "ubuntu-vm nicht erreichbar. Backup wird nicht gestartet."
    exit 0
fi

# Backup-Verzeichnis auf dem Laptop via SSH mounten (optional)
# Falls du SSHFS nutzen möchtest, aber wie die Borg-Dokumentation sagt, ist eine direkte SSH-Verbindung effizienter
# sshfs user@laptop:/path/to/dir /mnt/laptop_backup

# Remote-Verbindung zur ubuntu-vm herstellen und das Backup-Skript auf dem Laptop per SSH ausführen
ssh -i /home/murmeldin/.ssh/id_ed25519_backup ubuntu-vm << 'EOF'

    # Verschlüsselte Backup-Partition auf der VM mounten
    if ! mountpoint -q /mnt/backup; then
        echo "Mounting /dev/mapper/backup_crypt to /mnt/backup"
        sudo mount /dev/mapper/backup_crypt /mnt/backup
        if [ $? -ne 0 ]; then
            echo "Fehler beim Mounten der Backup-Partition. Skript abgebrochen."
            exit 1
        fi
    fi

    # Setting Borg environment variables
    export BORG_REPO='ssh://192.168.178.91:/run/media/murmeldin/backup_cold/borg'
    export BORG_RSH='ssh -i /home/murmeldin/.ssh/id_ed25519_backup'

    # Set Borg repository passphrase
    export BORG_PASSPHRASE=Vegan-King-Doctrine-Imagines9-Drained

    # some helpers and error handling:
    info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
    trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

    info "Starting backup"

    # Borg Backup: Backup des Verzeichnisses auf dem Laptop via SSH (dein Laptop)
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

EOF
