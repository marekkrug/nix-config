{ config, pkgs, ... }:

{
  home-manager.users.murmeldin = {
    dconf = {
      enable = true;
      settings."org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          apps-menu
          pomodoro
          blurt
          burn-my-windows
          alternate-tab
          Vitals
          blur-my-shell
          tiling-assistant
          #clipboard-indicator

        ];
      };
    };
  };
}