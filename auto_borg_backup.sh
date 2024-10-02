#!/usr/bin/env bash

# Check if the environment variable is already set to 'true'
if [[ "$AUTO_BASH_SCRIPT_CURRENTLY_RUNNING" == "true" ]]; then
    echo "The script is already running. Exiting..."
    exit 1
fi

# Set the environment variable to 'true' to prevent another instance from running
AUTO_BASH_SCRIPT_CURRENTLY_RUNNING=true
export AUTO_BASH_SCRIPT_CURRENTLY_RUNNING

# Run the backup script
sudo /home/murmeldin/.dotfiles/borg_backup.sh

# After the script completes, set the variable back to 'false'
AUTO_BASH_SCRIPT_CURRENTLY_RUNNING=false
export AUTO_BASH_SCRIPT_CURRENTLY_RUNNING

exit 0
