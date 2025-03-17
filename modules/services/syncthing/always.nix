{ config, pkgsStable, ... }: let
  secrets = config.sops.secrets;
in {
  # syncthing uses 8384 for remote access to GUI
  # 22000 TCP and UDP for sync traffic
  # 21027 UDP for discovery
  networking.firewall.allowedTCPPorts = [ 22000 ]; # // 8384
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  users.groups.synced = {};
  services = {
    syncthing = {
      enable = true;
      package = pkgsStable.syncthing;
      systemService = true;

      user = "syncthing";
      group = "synced";
      dataDir = "/synced/";
      configDir = "/synced/.config/";

      overrideDevices = true;
      overrideFolders = true;

      # required to prevent the id for syncthing from changing over time
      #key = ../../../hosts/${config.networking.hostName}/syncthing/key.pem;
      #cert = ./../../hosts/${config.networking.hostName}/syncthing/cert.pem;

      settings.gui = {
        user     = secrets."syncthing/gui/username";
        password = secrets."syncthing/gui/password";
      };
    };
  };

  # Don't create default ~/Sync folder
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

  sops.secrets = {
    "syncthing/gui/username" = {sopsFile = ./secrets.yaml;};
    "syncthing/gui/password" = {sopsFile = ./secrets.yaml;};
    "syncthing/archive-server/id" = {sopsFile = ./secrets.yaml;};
    "syncthing/snek/id" = {sopsFile = ./secrets.yaml;};
    "syncthing/mr-lemon/id" = {sopsFile = ./secrets.yaml;};
    "syncthing/beep-box/id" = {sopsFile = ./secrets.yaml;};
  };

}
