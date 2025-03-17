# Useful for maintaining nixos machines
{ pkgs, ... }: {
  imports = [
    ../apps-cli/nix-helper.nix
    ../apps-cli/dead-nix.nix
  ];

  environment.systemPackages = [
    pkgs.nix-inspect
  ];
}
