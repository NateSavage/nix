#  Scans Nix files for unused variable bindings https://github.com/astro/deadnix

{ pkgs, ... }: {
  config.environment.systemPackages = [
    pkgs.deadnix
  ];
}
