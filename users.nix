{ config, pkgs, ... }:

{
  users.defaultUserShell = pkgs.zsh;

  users.users.tks = {
    isNormalUser = true;
    description = "TKS";
    
    extraGroups = [ "networkmanager" "wheel" ]; 
  };
}