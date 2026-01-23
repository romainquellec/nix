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
    claude-code
    opencode
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
      save = 10000;
    };
    shellAliases = {
      update = "nix flake update --flake /home/tks/nixos-config";
      rebuild = "sudo nixos-rebuild switch --flake /home/tks/nixos-config#PCFix-nixos";
      clean = "sudo nix-collect-garbage -d && nix-store --optimise";
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

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/gh";
        user = "git";
      };
    };
  };

programs.git = {
    enable = true;
    
    settings = {
      user = {
        name = "romainquellec";
        email = "1150703+romainquellec@users.noreply.github.com";
      };

      gpg.format = "ssh";
      user.signingkey = "~/.ssh/gh.pub";
      commit.gpgsign = true;

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
      };
    };
  };

  services.ssh-agent.enable = true;

  programs.home-manager.enable = true;
}