{ config, ...}: {
  imports = [
    ../-features/always
    ../../modules/feature-sets/nix-hardening.nix
    #../../modules/apps/file-shelter.nix
    ../../users/nate
  ];

  i18n.defaultLocale = "en_AU.UTF-8";

  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    mirroredBoots = [
      { devices = [ "nodev"]; path = "/boot"; }
    ];
  };

  #ZFS
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [ "archive" ];
  services.zfs.autoScrub.enable = true;

  networking = {
    hostName = "nox";
    hostId = "b344a648";
  };

  system.stateVersion = "24.05";


  ####### Experimenting

  networking.firewall = {
    allowedTCPPorts = [ 80 443 2342 ];
  };

    # grafana configuration
    services.grafana = {
      enable = true;
      settings.analytics.reporting_enabled = false;
      settings.server = {
        domain = "monitor.panopticom.online";

        # listening address
        http_addr = "127.0.0.1";
        http_port = 2342;
      };
    };

    # reverse proxy

    services.haproxy = {
      enable = true;
      user = "haproxy";
      group = "haproxy";
      #package = pkgs.haproxy;
      config = builtins.readFile ./haproxy.cfg;
    };
    systemd.user.services.haproxy = {
      after = [ "prometheus.service" "grafana.service"];
    };


  services.prometheus = {
      enable = true;
      globalConfig.scrape_interval = "10s";
      port = 9001;

      exporters.node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };

      scrapeConfigs = [{
          job_name = "scrape-systemd";
          static_configs = [{ targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ]; }];
        } {
          job_name = "haproxy-metrics";
          static_configs = [{ targets = [ "localhost:8405" ]; }];
        }
      ];
    };

  # See https://search.nixos.org/options?channel=unstable&query=services.matrix-conduit.
    # and https://docs.conduit.rs/configuration.html
   # services.matrix-conduit = {
   #   enable = true;
   #   settings.global = {
   #     allow_registration = true;
   #     # You will need this token when creating your first account.
   #     registration_token = "A S3CR3T TOKEN!";
   #     server_name = panopticom.online;
   #      port = 9444;
   #     address = "::1";
   #     database_backend = "rocksdb";

        # See https://docs.conduit.rs/turn.html, and https://github.com/element-hq/synapse/blob/develop/docs/turn-howto.md for more details
        # turn_uris = [
        #  "turn:your.turn.url?transport=udp"
        #  "turn:your.turn.url?transport=tcp"
        # ];
        # turn_secret = "your secret";
   #   };
   # };


  ######################
}
