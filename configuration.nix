{ config, pkgs, ... }:

{
  imports =
    [
      ./modules/system.nix
      ./modules/desktop.nix
      ./modules/users.nix
    ];
}