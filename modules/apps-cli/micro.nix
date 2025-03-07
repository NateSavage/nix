# Terminal based text editor with mouse support https://micro-editor.github.io/

{ pkgs, ...}: {
   config.environment.systemPackages = [ pkgs.micro ];
}
