# Shared config for physical desktop/laptop machines (beepbox + snek)
{ config, ... }: let
  secrets = config.sops.secrets;
in {
  # EFI boot (not applicable to WSL)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;

  networking.networkmanager.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
  };

  hardware.graphics.enable = true;

  # Required for some app portals (e.g. Unity Hub sign-in)
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT    = "en_US.UTF-8";
    LC_MONETARY       = "en_US.UTF-8";
    LC_NAME           = "en_US.UTF-8";
    LC_NUMERIC        = "en_US.UTF-8";
    LC_PAPER          = "en_US.UTF-8";
    LC_TELEPHONE      = "en_US.UTF-8";
    LC_TIME           = "en_US.UTF-8";
  };

  # Syncthing (ports: 22000 sync, 21027 discovery, 8384 web UI)
  networking.firewall.allowedTCPPorts = [ 22000 8384 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  users.groups.sync = {};
  services.syncthing = {
    enable = true;
    systemService = true;
    user = "syncthing";
    group = "sync";
    dataDir = "/sync/";
    configDir = "/sync/.config/";

    settings = {
      options.limitBandwidthInLan = false;
      # TODO: syncthing NixOS module expects string values here, but sops provides
      # file paths. Replace with direct strings if this doesn't work as expected.
      gui = {
        user     = secrets."syncthing/gui/username".path;
        password = secrets."syncthing/gui/password".path;
      };
      devices."archive-server" = {
        id       = secrets."syncthing/archive-server/id".path;
        addresses = [ "dynamic" ];
      };
      folders."books" = {
        id      = "nate-books";
        path    = "~/sync/books";
        type    = "receiveonly";
        devices = [ "archive-server" ];
      };
    };
  };

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

  sops.secrets = {
    "syncthing/gui/username"       = { sopsFile = ../../secrets/syncthing.yaml; };
    "syncthing/gui/password"       = { sopsFile = ../../secrets/syncthing.yaml; };
    "syncthing/archive-server/id"  = { sopsFile = ../../secrets/syncthing.yaml; };
  };
}
