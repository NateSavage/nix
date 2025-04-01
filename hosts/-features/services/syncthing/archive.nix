{ config, ... }: let
    secrets = config.sops.secrets;
    nateClients = [ "snek" "beep-box" "foldy" ]; # "mr-lemon" ];
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
      "foldy" = {
        id = secrets."syncthing/foldy/id".path;
        name = "foldy";
        addresses = [ "dynamic" ];
      };
     # "mr-lemon" = {
     #   id = secrets."syncthing/mr-lemon/id".path;
     #   name = "mr-lemon";
     # };
    };
    folders = {
      # these are files we want sent to the archive and stored long term
      # it's an unsorted bucket that I'll figure out how I want to sort later
      "archive" = {
        id = "nate-archive-to-sort";
        path = "/sync/archive-to-sort";
        type = "receiveonly";
        devices = nateClients;
        #versioning =
      };
      #"/synced/3d-archive" = {

      #"/synced/projects" = {

      "books" = {
        id = "nate-books";
        path = "/sync/nate/books";
        type = "sendreceive";
        devices = nateClients;
        versioning = {
          type = "trashcan";
          params.cleanoutDays = "180";
        };
      };
      #"/synced/3d" = {
      #"/synced/photos" = {
      "music" = {
        id = "nate-music";
        path = "/sync/nate/music";
        type = "receiveonly";
        devices = nateClients;
      };
      #"/synced/videos" = {

      #"/synced/financial" = {
      #"/synced/medical" = {
      "mind" = {
        id = "nate-mind";
        path = "/sync/nate/mind";
        type = "sendreceive";
        devices = nateClients;
        versioning = {                                                                    
          type = "trashcan";                                                              
          params.cleanoutDays = "180";                                                   
        };
      };
    };
  };
}
