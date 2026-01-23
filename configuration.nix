{ config, pkgs, ... }:

{
  imports =
    [ 
      ./modules/hardware-configuration.nix
      ./modules/system.nix
      ./modules/desktop.nix
      ./modules/users.nix
    ];
}