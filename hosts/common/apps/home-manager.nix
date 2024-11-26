# https://nix-community.github.io/home-manager/index.xhtml#ch-installation

{ inputs, pkgs, outputs, ... }: {
  
  # uncertain if this is needed
  #imports = [
  #  inputs.home-manager.nixosModules.home-manager
  #];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };
}