#  Scans Nix files for unused variable bindings https://github.com/astro/deadnix

{nixpkgs, ...}: {
  environment.systemPackages = [
    nixpkgs.deadnix
  ];
}