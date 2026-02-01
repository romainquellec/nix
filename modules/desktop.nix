{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "intl";
    };
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  console.keyMap = "us-acentos";

  services.flatpak = {
    enable = true;
    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];
    packages = [
      "com.opera.Opera"
      "io.github.chidiwilliams.Buzz"
    ];
  };
}