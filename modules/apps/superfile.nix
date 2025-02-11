# spf (superfile) https://github.com/yorukot/superfile
{ config, pkgs, ...}: {
  home.packages = [
    #TODO: feed the host platform into the module as a variable
    # hostPlatform will probably look like "x86_64-linux"
    inputs.superfile.packages.x86_64-linux.default
  ];
}
