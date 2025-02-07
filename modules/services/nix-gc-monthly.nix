{ pkgs, ... }:
{
  environment.packages = [ pkgs.nh ];
  programs.nh = { enable = true; };
}