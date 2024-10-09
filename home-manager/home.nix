# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [

    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
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
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Set your username
  home = {
    username = "ks";
    homeDirectory = "/home/ks";
  };

  # List packages installed in user profile. 
  programs.neovim.enable = true;
  home.enableNixpkgsReleaseCheck = false;
  home.packages = with pkgs; [
    anydesk
    aseprite
    bottles
    deluge
    ffmpeg_7-full
    fontforge-gtk
    fzf
    gh
    gimp-with-plugins
    gitkraken
    google-chrome
    handbrake
    heroic
    imagemagick
    inkscape-with-extensions
    kdePackages.ark
    kdePackages.gwenview
    libreoffice-qt
    mangohud
    moonlight-qt
    nodejs_20
    obs-studio
    obsidian
    okular
    onlyoffice-bin_latest
    openmw-tes3mp
    p7zip
    plex
    plexamp
    prismlauncher
    puddletag
    retroarchFull
    rustdesk-flutter
    ryujinx
    temurin-bin-17
    unrar
    vesktop
    vlc
    wget
    yt-dlg
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
  };

  # Enable firefox and use the KDE file picker.
  programs.firefox = {
    enable = true;
  };

  # Enable VS Code
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [ ];
  };

  # Enable fd
  programs.fd = {
    enable = true;
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "spyrella";
    userEmail = "16845165+spyrella@users.noreply.github.com";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
