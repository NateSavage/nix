# Useful for maintaining nixos machines
{ pkgs, ... }: {
  imports = [
    ../apps-cli/nix-helper.nix
  ];

  environment.systemPackages = [
    pkgs.nix-inspect # allows browsing the derivation of a nix flake like a file tree to see what it resolves to
    pkgs.deadnix # invoke to check what is declared in a flake but not used
  ];
}
