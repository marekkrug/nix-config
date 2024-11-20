{ config, pkgs, ...}:
{

  # Battery Threshold settings:

  boot.kernelModules = [ "tp_smapi" ];

  environment.systemPackages = with pkgs; [ tp_smapi ];

  systemd.services.battery-charge-threshold = {
    description = "Set battery charging thresholds";
    wantedBy = [ "multi-user.target" ];
    after = [ "sys-devices-platform-smapi.device" ];
    script = ''
      echo 75 > /sys/devices/platform/smapi/BAT0/start_charge_thresh
      echo 85 > /sys/devices/platform/smapi/BAT0/stop_charge_thresh
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

}