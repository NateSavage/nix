#  Scans Nix files for unused variable bindings https://github.com/astro/deadnix

{ config, pkgs, ... }: {
  config.environment.systemPackages = [
    pkgs.deadnix
  ];
}
