{ config, pkgs, ... }:

{     
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
      Hostname github.com
      User git

      Host gitlab.com
      Hostname gitlab.com
      User git

      Host avd-power
      Hostname 195.160.172.25
      User power
      IdentityFile ~/.ssh/cccb-power

    Host snowden
      HostName snowden.berlin.ccc.de
      User murmeldin
      LocalForward 3948 hass.club.berlin.ccc.de:443
      LocalForward 5839 localhost:8006
      LocalForward 5647 172.23.43.147:80

    Host avd.club.berlin.ccc.de avd
      IdentityFile ~/.ssh/cccb-projekte
      # should be 195.160.172.24||avd.berlin.ccc.de| but doesn_t work
      # Hostname avd.club.berlin.ccc.de
      Hostname 195.160.172.24
      # Hostname 194.29.233.27
      # Hostname 172.23.42.106
      # Hostname 2001:678:560:42::24
      User murmeldin
      #User root
      ControlMaster yes
      ControlPath /tmp/ssh_control_%C
      LocalForward 8042 127.0.0.1:8042
      LocalForward 6006 127.0.0.1:6006
      LocalForward 9000 127.0.0.1:7860
      LocalForward 11434 127.0.0.1:1143

    Host nas-home
      Hostname fz6galkcgq4jhexn.myfritz.net
      User nas
      IdentityFile ~/.ssh/id_rsa.pub
      Port 11256
      LocalForward 8123 127.0.0.1:8123

    Host pc-home
      Hostname fz6galkcgq4jhexn.myfritz.net
      User murmeldin
      Port 11247
    Host pve-ubuntu
      Hostname 192.168.178.71
      User ubuntu-server
      Port 22

    Host ubuntu-vm
      Hostname fz6galkcgq4jhexn.myfritz.net
      User ubuntu-vm
      Port 11255

    Host ubuntu-vm.local
            Hostname 192.168.178.86
            User ubuntu-vm
            Port 22

    Host nobody-git
      HostName 217.115.15.84
      User git
      IdentityFile ~/.ssh/laptop-miracunix.pub

    Host netcup-vm
      Hostname netcup.marekkrug.de
      User netcup_vm
      Port 22
      IdentityFile ~/.ssh/id_netcup.pub
    '';
  };
}