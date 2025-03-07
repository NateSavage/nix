# Zed, a lovely text editor from the people who wrote Atom
#
#
{ pkgs, ... } : {
  environment.systemPackages = [
    pkgs.zed-editor
    pkgs.nixd # nix language server
  ];
}
