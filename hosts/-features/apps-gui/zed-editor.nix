# Zed, a lovely text editor from the people who wrote Atom
#
#
{ pkgs, pkgsUnstable, ... } : {
  environment.systemPackages = [
    pkgsUnstable.zed-editor
    pkgs.nixd # nix language server
  ];
}
