#  Scans Nix files for unused variable bindings https://github.com/astro/deadnix

{
  environment.systemPackages = [
    nixpkgs.deadnix
  ];
}