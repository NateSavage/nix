# spf (superfile) https://github.com/yorukot/superfile
{inputs}:{

  home.packages = home.packages ++ [
    # hostPlatform will probably look like "x86_64-linux"
    inputs.superfile.packages.${nixpkgs.hostPlatform}.default
  ];

}
