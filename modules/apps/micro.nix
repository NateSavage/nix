# Terminal based text editor with mouse support https://micro-editor.github.io/

{ config, pkgs, ...}: {
   config.environment.systemPackages = [ pkgs.micro ];
}
