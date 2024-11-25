{pkgs, ...}: {
  imports = [
    ../required
    ../feature-sets/nix-management.nix
  ];
}