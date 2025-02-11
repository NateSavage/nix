# Used to help bootstrap new NixOS installations.

{ pkgs ? import <nixpkgs> {}, ... }: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager

      git
      just
      micro
      nh

      sops
      ssh-to-age
      gnupg
      age
    ];
  };
}
