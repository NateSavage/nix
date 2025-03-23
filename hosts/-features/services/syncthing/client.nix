

{ config, ... }: let
    secrets = config.sops.secrets;
in {

  imports = [
    ./always.nix
  ];

  services.syncthing.settings = {

    devices = {
      "archive-server" = {
        id = secrets."syncthing/archive-server/id".path;
        name = "archive-server";
        addresses = [ "dynamic" ];
      };
    };

  };

}
