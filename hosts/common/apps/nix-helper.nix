# nh (yet another nix helper) https://github.com/viperML/nh
{ config, pkgs, ... }:
{
  environment.packages = [ pkgs.nh ];
  programs.nh = {
    enable = true;
    #clean.enable = true;
    #clean.extraArgs = "--keep-since 4d --keep 3";
    #flake = "/home/user/my-nixos-config";
  };
}