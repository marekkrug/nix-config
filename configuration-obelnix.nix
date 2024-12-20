# Notiz: command: sudo nixos-rebuild switch
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hw-config-obelnix.nix
    # Import other nix files from the system folder:
    #./system/mediawiki.nix
    ./system/smart-pricer.nix
    # <nixos/nixos/modules/virtualisation/virtualbox-image.nix> # If i should need an iso image
    ./system/borg-backup.nix
    ./system/enable-numlock.nix
    ./system/android.nix
    ./system/nvidia.nix
    #./system/cron.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.hostName = "obelnix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # rtkit is optional but recommended
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.murmeldin = {
    isNormalUser = true;
    description = "murmeldin";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      #minecraft
    ];
  };

  # Enable zshell as default:
  users.defaultUserShell = stablePkgs.zsh;

  programs = {
    firefox.enable = true;
    steam.enable = true;
    direnv.enable = true;
    zsh.enable = true;
  };

  nixpkgs = {
    overlays = [
      (final: prev: {
        nvchad = inputs.nvchad4nix.packages."${pkgs.system}".nvchad;
      })
    ];
    config = {
      # Allow unfree packages
      allowUnfree = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    #bitwarden-desktop
    thunderbird
    spotify
    vlc
    blender
    # Office:
    libreoffice
    #texstudio
    #texliveFull
    pandoc
    gparted
    gimp
    # Kommunikation:
    signal-desktop
    telegram-desktop
    element-desktop
    yt-dlp
    # Programming:
    #jetbrains.rust-rover
    rustup
    gccgo14
    openssl
    pkg-config
    vscodium
    vscode
    git
    sqlite
    #Terminal:
    tldr
    btop
    htop
    thefuck
    # Geld:
    monero-gui
    # NixOS:
    neofetch
    #just
    # AI Stuff:
    ollama
    upscayl
    chromium
    #sof-firmware
    tlp
    mission-center
    stress
    squashfsTools
    prusa-slicer
    powertop
    inkscape
    obsidian
    texliveSmall
    sof-firmware
    discord
    languagetool
    fasttext
    nix-output-monitor
    cabal-install
    ghc
    parted
    cryptsetup
    tree
    home-manager
    prismlauncher
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "jitsi-meet-1.0.8043"
  ];

  # Power management
  # services.tlp.enable = true;

  # Mullvad
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  services.mullvad-vpn = {
    enable = true;
  };

  # NixOS Virtualization:

  users.users.nixosvmtest.isSystemUser = true;
  users.users.nixosvmtest.initialPassword = "test";
  users.users.nixosvmtest.group = "nixosvmtest";
  users.groups.nixosvmtest = {};

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
      #
    };
  };

  environment.etc."lvm/lvm.conf".text = ''
    config {
    }
    devices {
      allow_mixed_block_sizes = 1
    }
  '';

  # Android vm:

  # virtualisation.waydroid.enable = true;

  # Auto-delete old generations:

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  #programs.OpenSSH

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
