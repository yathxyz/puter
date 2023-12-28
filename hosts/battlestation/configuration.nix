{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable flakes and the new command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages (unfortunately)
  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "nvidia_drm.modeset=1" ];
  };

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Networking
  networking.hostName = "battlestation"; # Define your hostname.
  services.openssh.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [];
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Dublin";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  environment.pathsToLink = [ "/libexec" ];

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";
      autoLogin = {
        enable = true;
        user = "yanni";
      };
    };

    windowManager.i3 = {
      enable = true;

      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
    };
  };

  services.dbus.enable = true;

  services.xserver = {
    layout = "us,gr";
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Set up docker for containers
  virtualisation.docker.enable = true;

  # Don't forget to set a password with ‘passwd’.
  users.users.yanni = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Ioannis Eleftheriou";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      home-manager
    ];
  };

  programs.kdeconnect.enable = true;

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    bc
    bison
    cmake
    coreutils-full
    curl
    direnv
    texlive.combined.scheme-full
    texlab
    fd
    gcc
    git
    gnumake
    libtool
    perl
    ripgrep
    sqlite
    wget
  ];

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    WORKDIR = "$HOME/work/";
  };

  fonts.packages = with pkgs; [
    nerdfonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ]; 


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
