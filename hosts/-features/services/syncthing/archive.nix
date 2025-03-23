{ config, ... }: let
    secrets = config.sops.secrets;
    allClients = [ "snek" "beep-box" ]; #"beepbox" "mr-lemon" ];
in {
  imports = [
    ./always.nix
  ];

  services.syncthing.guiAddress = "0.0.0.0:8384";
  services.syncthing.settings = {

    devices = {
      "snek" = {
        id = secrets."syncthing/snek/id".path;
        name = "snek";
        addresses = [ "dynamic" ];
      };
      "beep-box" = {
        id = secrets."syncthing/beep-box/id".path;
        name = "beep-box";
        addresses = [ "dynamic" ];
      };
     # "mr-lemon" = {
     #   id = secrets."syncthing/mr-lemon/id".path;
     #   name = "mr-lemon";
     # };
    };
    folders = {
      "/synced/archive" = {
        id = "nate-archive";
        type = "sendreceive";
        devices = allClients;
        #versioning =
      };
      #"/synced/3d-archive" = {

      #"/synced/projects" = {

      "/synced/books" = {
        id = "nate-books";
        type = "sendreceive";
        devices = allClients;
        versioning = {
          type = "trashcan";
          params.cleanoutDays = "180";
        };
      };
      #"/synced/3d" = {
      #"/synced/photos" = {
      "/synced/music" = {
        id = "nate-music";
        type = "receiveonly";
        devices = allClients;
      };
      #"/synced/videos" = {

      #"/synced/financial" = {
      #"/synced/medical" = {
      #"/synced/mind" = {
    };
  };
}
