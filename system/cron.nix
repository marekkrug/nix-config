{ config, pkgs, ... }:
{
    services.cron = {
    enable = true;
    systemCronJobs = [
      "*/30 * * * * sudo /home/murmeldin/.dotfiles/borg_backup.sh"
    ];
  };

}