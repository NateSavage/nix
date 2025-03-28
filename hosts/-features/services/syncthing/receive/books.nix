{

  services.syncthing.settings.folders = {
    "books" = {
      id = "nate-books";
      path = "~/sync/books";
      type = "receiveonly";
      devices = [ "archive-server" ];
    };
  };
}
