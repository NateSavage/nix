{ config, ... }: let
    secrets = config.sops.secrets;
    allClients = [ "snek" "beepbox" "mr-lemon" ];
in {
  imports = [
    ./always.nix
  ];

  services.syncthing.settings = {

    devices = {
      "snek" = {
        id = secrets."syncthing/snek/id".path;
        name = "snek";
      };
      "beepbox" = {
        id = secrets."syncthing/beepbox/id".path;
        name = "beepbox";
      };
      "mr-lemon" = {
        id = secrets."syncthing/mr-lemon/id".path;
        name = "mr-lemon";
      };
    };
    folders = {
      "/synced/archive" = {
        id = "archive";
        type = "sendreceive";
        devices = allClients;
        #versioning =
      };
      #"/synced/3d-archive" = {

      #"/synced/projects" = {

      #"/synced/books" = {
      #"/synced/3d" = {
      #"/synced/photos" = {
      "/synced/music" = {
        id = "music";
        type = "receive";
        devices = allClients;
      };
      #"/synced/videos" = {

      #"/synced/financial" = {
      #"/synced/medical" = {
      #"/synced/mind" = {
    };
  };
}
