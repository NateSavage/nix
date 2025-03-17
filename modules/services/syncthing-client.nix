

{ pkgsStable, ... }: {

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
      user = "syncthing";
      group = "synced";
      configDir = "/synced/.config/";
      dataDir = "/synced/";
      systemService = true;
    };
  };
}
