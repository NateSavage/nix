{

  services.syncthing.settings.folders = {
    "/synced/books" = {
      id = "nate-books";
      type = "receiveOnly";
      devices = "archive-server";
    };
  };
}
