# nh (yet another nix helper) https://github.com/viperML/nh
# relies on git
# relies on experimental flakes features

{ config, pkgs, ... }:
{
  programs.git = { enable = true; }
  nix.settings.experimental-features = "nix-command flakes";
  programs.nh = {  enable = true; };
}