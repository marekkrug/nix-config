{ config, pkgs, ... }:

{
  systemd.user.timers."numlockx_boot" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
    OnStartupSec = "1us";
    AccuracySec = "1us";
    Unit = "numlockx.service";
    };
  };

  systemd.user.timers."numlockx_sleep" = {
    wantedBy = [
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
      "suspend-then-hibernate.target"
    ];
    after = [
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
      "suspend-then-hibernate.target"
    ];
    timerConfig = {
      AccuracySec = "1us";
      Unit = "numlockx.service";
    };
  };

  systemd.user.services."numlockx" = {
    script = "
      ${pkgs.numlockx}/bin/numlockx on
    ";
    serviceConfig = {
      Type = "oneshot"; # "simple" für Prozesse, die weiterlaufen sollen
    };
  };
}