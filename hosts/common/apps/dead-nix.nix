#  Scans Nix files for unused variable bindings https://github.com/astro/deadnix

{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.deadnix
  ];
}