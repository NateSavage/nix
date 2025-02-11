# https://nix-community.github.io/home-manager/index.xhtml#ch-installation
# depends on git
# depends on experimental flakes features

{ inputs, config, pkgs, outputs, ... }: {

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = {
  	nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

    programs.git.enable = true;

    home-manager.extraSpecialArgs = { inherit inputs outputs; };
  };

}
