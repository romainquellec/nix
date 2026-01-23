{ config, pkgs, ... }:

{
  home.username = "tks";
  home.homeDirectory = "/home/tks";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    vscode
    github-desktop
    lazygit
    ghostty
    nnn
    firefox
    firefox-devedition-unwrapped
    chromium
    google-chrome
    vivaldi
    librewolf
    brave
    discord
    slack
    obsidian
    libreoffice
    homebank
    portfolio
    calibre
    vlc
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      update = "nix flake update";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#PCFix-nixos";
      clean = "sudo nix-collect-garbage -d && nix-store --optimise";
    };
  };

  programs.git = {
    enable = true;
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
    
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
    };
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "dark";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
    };
  };

  programs.home-manager.enable = true;
}