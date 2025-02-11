# regularly clean out

{ nixpkgs, ... }:
{
  environment.packages = [ nixpkgs.nh ];
  programs.nh = { enable = true; };
}
