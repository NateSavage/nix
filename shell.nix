# Bootstrap shell for setting up or managing machines.
# Usage: nix-shell  (or: nix develop)

{ pkgs ? import <nixpkgs> {} }: pkgs.mkShell {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes";
  nativeBuildInputs = with pkgs; [
    nix
    git
    just
    micro
    nh

    sops
    ssh-to-age
    age
  ];
}
