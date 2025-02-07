# https://nix-community.github.io/home-manager/index.xhtml#ch-installation
# depends on git
# depends on experimental flakes features

{ inputs, nixpkgs, outputs, ... }: {

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  nix = {
    package = nixpkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs.git = { enable = true; };

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };
}