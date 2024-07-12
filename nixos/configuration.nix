# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
      };
      # Opinionated: disable channels
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  # Current Configuration

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # Set your hostname
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Open up network ports
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      47984
      47989
      47990
      48010
    ];
    allowedUDPPortRanges = [
      {
        from = 47998;
        to = 48000;
      }
      {
        from = 8000;
        to = 8010;
      }
    ];
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # Enable Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  boot.blacklistedKernelModules = [ "nouveau" ];

  # Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    ks = {
      initialPassword = "password";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };

  # Set up flake dotfile variable
  environment.sessionVariables = {
    FLAKE = "/home/ks/Work/dotfiles";
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    git
    gparted
    lutris
    nh
    nix-output-monitor
    nixfmt-rfc-style
    nvd
    piper
    pm2
    protonup
    winetricks
    wineWowPackages.waylandFull
    yarn
  ];

  # Enable GameMode, a daemon/lib combo optimizes OS for games.
  # To make sure Steam starts a game with GameMode
  # gamemoderun %command%
  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true; # Enables features such as resolution upscaling and stretched aspect ratios
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # List services that you want to enable:

  # Enable Wayland and Plasma 6
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "ks";

  # Enabling native wayland support
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Exclude the following kde packages
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    kate
  ];

  # Enable Tailscale
  services.tailscale.enable = true;

  # Enable Syncthing
  services.syncthing = {
    enable = true;
    user = "ks";
    dataDir = "/home/ks/Documents";
    configDir = "/home/ks/.config/syncthing";
  };

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable OpenRGB server, for RGB lighting control.
  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.motherboard = "amd";

  # Enable touchpad support.
  services.libinput.enable = true;

  # Enable ratbagd for configuring gaming mice.
  services.ratbagd.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Sunshine, a self-hosted game stream host for Moonlight.
  services.sunshine.enable = true;

  # Setup SSH server.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
