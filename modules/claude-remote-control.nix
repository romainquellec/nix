{ config, pkgs, lib, inputs, ... }:

# Lance `claude remote-control` automatiquement à la connexion, un service
# systemd utilisateur par dossier. Claude Desktop (Linux, non officiel) ne sait
# pas démarrer Claude Code pour Remote Control : ces services le remplacent.
#
# Prérequis (une seule fois par dossier) : lancer `claude remote-control` dans
# un terminal depuis ce dossier et répondre « y » (activation + confiance du
# dossier). Ensuite le service tourne sans terminal.
let
  claude-code = inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
  home = config.home.homeDirectory;

  # nom du service => dossier servi
  folders = {
    nixos-config = "${home}/nixos-config";
    notes = "${home}/notes";
  };

  # Outils dont Claude a besoin dans les sessions lancées par le service
  # (le service ne passe pas par zsh, donc pas de PATH de session).
  path = lib.concatStringsSep ":" [
    (lib.makeBinPath (with pkgs; [ claude-code git nix bash coreutils findutils gnugrep gnused gawk openssh ripgrep ]))
    "/run/wrappers/bin"
    "${home}/.nix-profile/bin"
    "/etc/profiles/per-user/${config.home.username}/bin"
    "/nix/var/nix/profiles/default/bin"
    "/run/current-system/sw/bin"
  ];

  mkService = name: dir: lib.nameValuePair "claude-rc-${name}" {
    Unit = {
      Description = "Claude Remote Control (${dir})";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
      # Ne pas abandonner après plusieurs échecs (réseau absent au démarrage, etc.)
      StartLimitIntervalSec = 0;
      # Ignoré proprement si le dossier n'existe pas sur cette machine
      ConditionPathIsDirectory = dir;
    };
    Service = {
      WorkingDirectory = dir;
      Environment = [
        "PATH=${path}"
        "HOME=${home}"
        "SHELL=${pkgs.bash}/bin/bash"
        # agent SSH de home-manager (services.ssh-agent), pour git push
        "SSH_AUTH_SOCK=%t/ssh-agent"
      ];
      ExecStart = "${claude-code}/bin/claude remote-control --spawn=same-dir";
      Restart = "always";
      RestartSec = 15;
    };
    Install.WantedBy = [ "default.target" ];
  };
in
{
  systemd.user.services = lib.mapAttrs' mkService folders;
}
