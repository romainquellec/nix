{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "PCFix-nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "fr_FR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver = {
    xkb.layout = "fr";
    xkb.variant = "us";
  };

  console.keyMap = "fr";

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      update = "sudo nixos-rebuild switch";
    };
  };
  users.defaultUserShell = pkgs.zsh;
  
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  users.users.tks = {
    isNormalUser = true;
    description = "TKS";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      beekeeper-studio bruno lazygit firefox firefox-devedition-unwrapped chromium google-chrome vivaldi librewolf brave vlc logseq libreoffice discord slack github-desktop nodejs_22 yarn docker docker-compose vscode yarn logseq
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget git lazygit helix zsh wezterm fastfetch cpufetch btop eza bat fd nnn fzf nerdfonts tmux
  ];
  
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  system.stateVersion = "24.05";
}
