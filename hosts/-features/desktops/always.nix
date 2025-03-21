# things shared between all desktop environments
#
#

{ pkgs, pkgsUnstable, ... } : {

  imports = [
    ../apps-cli/app-image-run.nix
    ../services/flatpak.nix

    ../apps-gui/zed-editor.nix
    ../apps-gui/local-send.nix

    ../apps-gui/godot-4-mono.nix
  ];

  programs.firefox.enable = true;

  environment.systemPackages = [
    pkgs.mission-center
    pkgs.fsearch # replacement for everything by voidtools on windows
    pkgs.bleachbit

    pkgs.onlyoffice-desktopeditors
    pkgs.github-desktop
    pkgs.proton-pass
    pkgs.obsidian
    pkgs.blender
   # pkgsUnstable.jetbrains.rider
  ];
}
