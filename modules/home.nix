{ config, pkgs, ... }:

{
  home.username = "tks";
  home.homeDirectory = "/home/tks";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    android-tools
    brave
    calibre
    claude-code
    chromium
    discord
    firefox
    firefox-devedition-unwrapped
    ghostty
    github-desktop
    google-chrome
    homebank
    lazygit
    lazysql
    libreoffice
    nnn
    obsidian
    opencode
    portfolio
    scrcpy
    slack
    vlc
    vscode
    vivaldi
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
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
    ];
    initExtraBeforeCompInit = ''
      fpath+="${pkgs.zsh-completions}/share/zsh/site-functions"
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "Catppuccin Mocha";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
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
