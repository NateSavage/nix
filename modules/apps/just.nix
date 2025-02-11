# just a command runner https://github.com/casey/just

{ config, pkgs, ...}: {
  config.environment.systemPackages = [ pkgs.just ];
}
