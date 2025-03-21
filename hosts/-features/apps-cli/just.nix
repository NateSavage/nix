# just a command runner https://github.com/casey/just

{ pkgs, ...}: {
  config.environment.systemPackages = [ pkgs.just ];
}
