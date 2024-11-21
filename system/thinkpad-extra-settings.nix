{ config, pkgs, ...}:
{
  # --- Maximal 85 % Laden zum akku schonen: ---

  # METHOD WITHOUT POWER PROFILES:
  # services.power-profiles-daemon.enable = false;
  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     START_CHARGE_THRESH_BAT0 = 75;
  #     STOP_CHARGE_THRESH_BAT0 = 85;
  #   };
  # };

  # METHOD WITH POWER PROFILES:

  boot.kernelModules = [ "acpi_call" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];

  services.power-profiles-daemon.enable = true;

  systemd.services.battery-charge-threshold = {
    description = "Set battery charging thresholds";
    wantedBy = [ "multi-user.target" ];
    after = [ "lvm2-activation.service" ];
    script = ''
      echo 75 > /sys/class/power_supply/BAT0/charge_control_start_threshold
      echo 85 > /sys/class/power_supply/BAT0/charge_control_end_threshold
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  # --- Fingerabdruckscanner stuff ---
  # Start the driver at boot
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  environment.systemPackages = with pkgs; [
    fprintd
  ];

  # Install the driver
  services.fprintd.enable = true;
  # If simply enabling fprintd is not enough, try enabling fprintd.tod...
  # services.fprintd.tod.enable = true;
  # ...and use one of the next four drivers
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix; # Goodix driver module
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-elan # Elan(04f3:0c4b) driver
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090; # driver for 2016 ThinkPads
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix-550a # Goodix 550a driver (from Lenovo)
}