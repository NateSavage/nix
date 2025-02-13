# A simple file sharing web server 
# https://github.com/epoupon/fileshelter

{ config, pkgs, ... }: {
   config.environment.systemPackages = [
    pkgs.fileshelter
  ];
}
