{ config, pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../-features/always
    ../-features/security/nix-hardening.nix

    ../-features/services/openssh.nix
    ../-features/services/syncthing/archive.nix
    ../-features/services/forgejo.nix
    #../../modules/apps/file-shelter.nix
    ../../users/nate
    ../../users/beak
  ];

  i18n.defaultLocale = "en_AU.UTF-8";
  
  programs.git = {
      enable = true;
      lfs.enable = true;
  };
  
  
  # samba
  
  users.groups.eromancer = {};
  users.groups.panopticom = {};
  users.groups.future-way-designs= {};
  
  sops.secrets = {
      "panopticom/github-runner-token" = {
        sopsFile = ./secrets.yaml;
        #owner = "github-runner-panopticom";
        path = "/secrets/panopticom-github-token";
      };
      
      "eromancer/github-runner-token" = {
            sopsFile = ./secrets.yaml;
            #owner = "github-runner-eromancer";
            path = "/secrets/eromancer-github-token";
          };
    };
    
    services = {
    
      github-runners = {
        panopticom = {
            enable = true;
            name = "panopticom-runner";
            tokenFile = "/secrets/panopticom-github-token";
            url = "https://github.com/panopticom";
          };
          eromancer = {
            enable = true;
            name = "eromancer-runner";
            tokenFile = "/secrets/eromancer-github-token";
            url = "https://github.com/eromancer-games";
          };
      };
    
    #github-nix-ci = {
      #age.secretsDir = ./secrets; # Only if you use agenix
     # extraPackages = [ 
      #  "just"
       # "ion"
      #];
      #orgRunners = {
       # "panopticom".num = 3; # num is the number of parallel runners allowed
      #  "Eromancer-Games".num = 3;
      #};
    #};
  
    samba = {
      enable = true;
      openFirewall = true;
      package = pkgs.samba4Full;
      # ^^ `samba4Full` is compiled with avahi, ldap, AD etc support (compared to the default package, `samba`
      # Required for samba to register mDNS records for auto discovery 
      # See https://github.com/NixOS/nixpkgs/blob/592047fc9e4f7b74a4dc85d1b9f5243dfe4899e3/pkgs/top-level/all-packages.nix#L27268
          
      settings = {
    
        global = {
          # debug
          "log level" = 3;
        
          # server metadta
          "server string" = "nox";
          "netbios name" = "nox";
        
          "server role" = "standalone";
        
          # security settings
          "security" = "user"; # one of "auto", "user", "domain", "ads"
          #"workgroup" = "WORKGROUP";
          "passdb backend" = "smbpasswd";
          #"unix password sync" = "yes";
          #"use sendfile" = "yes";
          #"winbind use default domain" = "yes";
        
          "dns proxy" = "no";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "192.168.251.47 10.189.189.249 192.168.251. 127.0.0.1 localhost BeepBox OnePlus-Open foldy snek";
          "hosts deny" = "0.0.0.0/0";
        


        
          "idmap config * : backend" = "tdb";
          "idmap config * : range" = "10000-20000";
        
          # hardening
          "invalid users" = ["root"];
          "server min protocol" = "SMB3";
          #"acl allow execute always" = "true";  # Enable NT ACL support
        
          # performance tuning
        
      
          # file settings
          # do not mangle file names
          "case sensitive" = "auto";  # yes/no/auto
          "default case"   = "lower"; # upper/lower
          "preserve case"  = "yes";   # yes/no
          #"store dos attributes" = "yes";
        
        
          # account mapping
          "username map" = builtins.toString (builtins.toPath ./username-map); # path as string to load username map
          "guest account" = "anyone";
        
        
          #sharing
          #"usershare path" = "/var/lib/samba/usershares"; #openzfs doesn't allow this to be anywhere else
          #"usershare max shares" = "10";
          #"usershare allow guests" = "yes";
          #"usershare owner only" = "no";
        };
      
        # for windows compatibility, you must run the following commands on a zfs data share
        # sudo zfs set acltype=posix <datashare>
        # sudo zfs set aclmode=passthrough <datashare>
        # sudo zfs set aclinherit=passthrough <datashare>
      
      
        ### File Permission Templates
        /*
        PublicReadGroupDeleteFilePermissions = {
          # for files, owner must have read-write. group must have read-write. others must have read. no one may execute code on the server
          "force create mode"    = "0664"; # default: 0000 the minimum permissions for a file created in this share
          "create mask"          = "0664"; # default: 0744 any bit not set in this mask will be removed from the permissions for newly created files
          # for directories, owner must have read-write-browse. group must have read-write-browse. others must have read, may have browse.
          "force directory mode" = "0774"; # default: 0000 the minimum permissions for a directory created in this share
          "directory mask"       = "0775"; # default: 0755 any bit not set in this mask will be removed from the permissions for newly created directories
        };
      
        PublicReadOwnerDeleteFilePermissions = {
          # for files, owner must have read-write. group must have read-write. others must have read. no one may execute code on the server
          "force create mode"    = "0644"; # default: 0000 the minimum permissions for a file created in this share
          "create mask"          = "0644"; # default: 0744 any bit not set in this mask will be removed from the permissions for newly created files
          # for directories, owner must have read-write-browse. group must have read, may have browse. others must have read, may have browse.
          "force directory mode" = "0744"; # default: 0000 the minimum permissions for a directory created in this share
          "directory mask"       = "0755"; # default: 0755 any bit not set in this mask will be removed from the permissions for newly created directories
        };
      
      
        GroupReadWriteFilePermissions = {
          # for files, owner must have read-write. group must have read-write. others must have nothing. no one may execute code on the server
          "force create mode"    = "0660"; # default: 0000 the minimum permissions for a file created in this share
          "create mask"          = "0660"; # default: 0744 any bit not set in this mask will be removed from the permissions for newly created files
          # for directories, owner must have read-write-browse. group must have list directory contents, enter directory, and create/delete. others must hav nothing.
          "force directory mode" = "0770"; # default: 0000 the minimum permissions for a directory created in this share
          "directory mask"       = "0770"; # default: 0755 any bit not set in this mask will be removed from the permissions for newly created directories
        };
        */
        ### File Permission Templates^
        
        
        public = {
          "path" = "/mnt/arc/public";
          "available" = "yes";
          "browseable" = "yes";
          "writeable" = "yes";
          "guest ok" = "yes";
          "map to guest" = "Bad User";
                
          # file permissions
          "force create mode"    = "0666";
          "create mask"          = "0666";

          "force directory mode" = "0777"; 
          "directory mask"       = "0777";
        
          "force group" = "anyone";
        };
      

      archive = {
        "path" = "/mnt/arc/archive";
        "available" = "yes";
        "browseable" = "yes";
        "writeable" = "yes";
        "guest ok" = "no";
        
        # file permissions
        # for files, owner must have read-write. group must have read-write. others must have nothing. no one may execute code on the server
        "force create mode"    = "0660"; # default: 0000 the minimum permissions for a file created in this share
        "create mask"          = "0660"; # default: 0744 any bit not set in this mask will be removed from the permissions for newly created files
        # for directories, owner must have read-write-browse. group must have list directory contents, enter directory, and create/delete. others must hav nothing.
        "force directory mode" = "0770"; # default: 0000 the minimum permissions for a directory created in this share
        "directory mask"       = "0770"; # default: 0755 any bit not set in this mask will be removed from the permissions for newly created directories
        
        "force group" = "+home"; #if the user is in the home group, make it their primary group when interfacing through samba
      };
      
      stash = {
        "path" = "/mnt/arc/stash";
        "available" = "yes";
        "browseable" = "no";
        "writeable" = "yes";
              
        "guest ok" = "no";
        "valid users" = "nate";
              
        # file permissions
        "force create mode"    = "0600"; 
        "create mask"          = "0600"; 
              
        "force directory mode" = "0700";
        "directory mask"       = "0700";
      };
            
      "beaky-backup" = {
        "path" = "/mnt/arc/beaky-backup";
        "browseable" = "yes";
        "writeable" = "yes";
        "guest ok" = "no";
                    
        # file permissions
        # for files, owner must have read-write. group must have read-write. others must have nothing. no one may execute code on the server
        "force create mode"    = "0660"; # default: 0000 the minimum permissions for a file created in this share
        "create mask"          = "0660"; # default: 0744 any bit not set in this mask will be removed from the permissions for newly created files
        # for directories, owner must have read-write-browse. group must have list directory contents, enter directory, and create/delete. others must hav nothing.
        "force directory mode" = "0770"; # default: 0000 the minimum permissions for a directory created in this share
        "directory mask"       = "0770"; # default: 0755 any bit not set in this mask will be removed from the permissions for newly created directories        
                    
        "force group" = "+home"; #if the user is in the panopticom group, make it their primary group when interfacing through samba
       };
      
      
      panopticom = {
        "path" = "/mnt/arc/panopticom";
        #"valid users" = "nate";
        "browseable" = "no";
        "writeable" = "yes";
        "guest ok" = "no";
        
        # file permissions
        # for files, owner must have read-write. group must have read-write. others must have nothing. no one may execute code on the server
        "force create mode"    = "0660"; # default: 0000 the minimum permissions for a file created in this share
        "create mask"          = "0660"; # default: 0744 any bit not set in this mask will be removed from the permissions for newly created files
        # for directories, owner must have read-write-browse. group must have list directory contents, enter directory, and create/delete. others must hav nothing.
        "force directory mode" = "0770"; # default: 0000 the minimum permissions for a directory created in this share
        "directory mask"       = "0770"; # default: 0755 any bit not set in this mask will be removed from the permissions for newly created directories        
        
        #"force user" = "nate";
        "force group" = "+panopticom"; #if the user is in the panopticom group, make it their primary group when interfacing through samba
      };
      
      eromancer = {
        "path" = "/mnt/arc/eromancer";
        "browseable" = "no";
        "writeable" = "yes";
        "guest ok" = "no";
        "valid users" = "nate";
          
          # for files, owner must have read-write. group must have read-write. others must have nothing. no one may execute code on the server
          "force create mode"    = "0660"; # default: 0000 the minimum permissions for a file created in this share
          "create mask"          = "0660"; # default: 0744 any bit not set in this mask will be removed from the permissions for newly created files
          # for directories, owner must have read-write-browse. group must have list directory contents, enter directory, and create/delete. others must hav nothing.
          "force directory mode" = "0770"; # default: 0000 the minimum permissions for a directory created in this share
          "directory mask"       = "0770"; # default: 0755 any bit not set in this mask will be removed from the permissions for newly created directories
                  
          "group" = "+eromancer"; #if the user is in the eromancer group, make it their primary group when interfacing through samba
        };
      
        "future-way-designs" = {
          "path" = "/mnt/arc/future-way-designs";
          "browseable" = "no";
          "writeable" = "yes";
          "guest ok" = "no";
          "valid users" = "nate";
          
          # for files, owner must have read-write. group must have read-write. others must have nothing. no one may execute code on the server
          "force create mode"    = "0660"; # default: 0000 the minimum permissions for a file created in this share
          "create mask"          = "0660"; # default: 0744 any bit not set in this mask will be removed from the permissions for newly created files
          # for directories, owner must have read-write-browse. group must have list directory contents, enter directory, and create/delete. others must hav nothing.
          "force directory mode" = "0770"; # default: 0000 the minimum permissions for a directory created in this share
          "directory mask"       = "0770"; # default: 0755 any bit not set in this mask will be removed from the permissions for newly created directories
                  
          "group" = "+future-way-designs"; #if the user is in the future-way-designs group, make it their primary group when interfacing through samba
        };
      };
    };
      
    # This enables autodiscovery on windows since SMB1 (and thus netbios) support was discontinued
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };  
  };
  networking.firewall.allowPing = true;
  

  #boot.loader.grub = {
  #  enable = true;
  #  zfsSupport = true;
  #  efiSupport = true;
  #  mirroredBoots = [
  #    { devices = [ "nodev"]; path = "/boot"; }
  #  ];
  #};
  
  services.the-forest-server = {
    enable = false;
    serverName = "We have to go back to the island";
    serverIP = "192.168.251.80";
  };

  #ZFS
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [ "arc" ];
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
