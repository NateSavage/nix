# https://nix-community.github.io/home-manager/index.xhtml#ch-installation
# depends on git
# depends on experimental flakes features

{ inputs, outputs, ... }: {

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = {
  	nix = {
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

    programs.git.enable = true;

    home-manager = {
      backupFileExtension = "backup";
      extraSpecialArgs = { inherit inputs outputs; };
    };

  };

}
