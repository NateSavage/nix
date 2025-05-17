{config, pkgs, options, lib, utils, ... }: 
let
   cfg = config.services.${app-name};
   opt = options.services.${app-name};
  
	 # Set to {id}-{branch}-{password} for betas.
	 steam-app-id = "556450";
	 app-name = "the-forest-server";
	 
	 # we need the X Virtual Frame Buffer because I have yet to figure out how to get the server to start without trying to open a window,
	 # even though it's starting in headless mode with no graphics
	 x-virtual-framebuffer-run = lib.getExe pkgs.xvfb-run;
	 wine-exe = lib.getExe pkgs.wineWowPackages.stable; #wineWow uses 32 bit or 64 bit wine automatically to match the host machine's architecture
	 server-exe = lib.escapeShellArg cfg.dataDir + "/TheForestDedicatedServer.exe";
   install-directory = lib.escapeShellArg cfg.dataDir;
	 
	 valueFlag = name: value:
	   lib.optionalString (value != null) "-${name} \"${lib.escape [ "\\" "\"" ] (toString value)}\"";
	   
	 boolFlag = name: val: lib.optionalString val "-${name}";
	 
	 flags = [
	   # mandatory flags
	   (boolFlag "batchmode" true)  # unity engine argument. "Run the application in “headless” mode. In this mode, the application doesn’t display anything or accept user input."
	   (boolFlag "nographics" true) # Unity engine argument. "When you use this argument in batch mode, Unity doesn’t initialize a graphics device. This makes it possible to run your automated workflows on machines that don’t have a GPU.""
	   # no graphics does allow the server to run, however we're spewing alot of errors about being unable to create a render texture because we have no graphics device
	   # I suspect that we'll get better performance if we can hook opengl up to the virtual display we're feeding wine.
	   
	  # server config flags
	  (valueFlag "serverip" cfg.serverIP)
	  (valueFlag "serversteamport" cfg.steamPort)
	  (valueFlag "servergameport" cfg.gamePort)
	  (valueFlag "serverqueryport" cfg.queryPort)
	  
	  (valueFlag "enableVAC" cfg.enableVAC)
	  (valueFlag "serverautosaveinterval" cfg.serverAutoSaveInterval)
	  
	  (valueFlag "servername" cfg.serverName)
	  (valueFlag "serverplayers" cfg.maxPlayers)
	  
	  # world configuration flags
	  (valueFlag "difficulty" cfg.difficulty)
	  (valueFlag "treeregrowmode" cfg.treesRegrow)
	  (valueFlag "nobuildingdestruction" cfg.maxPlayers)
	  
	  #(valueFlag "inittype" cfg.initType)
	 ];
	 
in {

  options.services.${app-name} = {
  
    enable = lib.mkEnableOption ''
      If enabled The Forest game server will be started with the host, and restarted automatically if it crashes.
      '';
    
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/${app-name}";
      example = "/srv/${app-name}";
      description = "Path to where the server should store variable data such as game saves.";
    };
    
    # networking
    serverIP = lib.mkOption {
      type = lib.types.str;
      description = "MUST be set to the IP address of the machine hosting the server on the local network.";
    };
     
    steamPort = lib.mkOption {
      type = lib.types.port;
      default = 8766;
      description = "UDP port for communication with steam";
    };
    gamePort = lib.mkOption {
      type = lib.types.port;
      default = 27015;
      description = "UDP port for game synchronization";
    };
    queryPort = lib.mkOption {
      type = lib.types.port;
      default = 27016;
      description = "UDP port";
    };
    
    
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to open ports in the firewall";
    };
    
    # game world settings
    
    serverName = lib.mkOption {
      type = lib.types.str;
      default = "The Forest on NixOS";
      description = "";
    };
    
    maxPlayers = lib.mkOption {
      type = lib.types.int;
      default = 8;
      description = "Maximum amount of players that can be connected at the same time.";
    };
    
    enableVAC = lib.mkOption {
      type = lib.types.string;
      default = "off";
      description = "Enable Valve Anti-Cheat for the server.";
    };
    
    serverAutoSaveInterval = lib.mkOption {
      type = lib.types.int;
      default = 15;
      description = "Time between server auto saves in minutes";
    };
    
    treesRegrow = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "When true, 10% of tree stumps regrow when players sleep.";
    };
    
    noBuildingDestruction = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "When true, players and enemies cannot destroy buildings.";
    };
    
    difficulty = lib.mkOption {
      type = lib.types.enum [
        "Peaceful"
        "Normal"
        "Hard"
      ];
      default = "Normal";
    };
    
    
    initType = lib.mkOption {
      type = lib.types.enum [
        "New"
        "Continue"
      ];
      default = "New";
    };
    
    saveSlot = lib.mkOption {
      type = lib.types.enum [ "1" "2" "3" "4" "5" ];
      default = "1";
    };
    
    enableLogWindow = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "When true, players and enemies cannot destroy buildings.";
    };
    
    veganMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "When true, no enemies.";
    };


    vegetarianMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "When true, no enemies during daytime.";
    };


    resetHolesMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "When true, resets all existing floor holes when loading a save.";
    };


    allowEnemiesInCreative = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "When true, players and enemies cannot destroy buildings.";
    };


    allowCheats = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "When true, players and enemies cannot destroy buildings.";
    };


    
  };
  
  
  config = lib.mkIf cfg.enable {
  
  	users.groups.${app-name} = {};
	  users.users.${app-name} = {
	    description = "The Forest game server service user.";
      isSystemUser = true;
		  home = cfg.dataDir;
		  createHome = true;
		  homeMode = "750";
		  group = app-name;
	  };

	  networking.firewall = lib.mkIf cfg.openFirewall {
	    allowedUDPPorts = [
	  	  cfg.steamPort
	  	  cfg.gamePort
	  	  cfg.queryPort
	  	];
	  };
	  

	   #environment.systemPackages = [
    #   pkgs.xorg.xvfb
   #  ];
	  
	  #environment = {
	  	# linux64 directory
	  	#LD_LIBRARY_PATH = "/var/lib/steam-app-${app-id}/linux64:${pkgs.glibc}/lib";
	  	#SteamAppId = app-id;
	  #};
	  
	  hardware.graphics.enable = true;

	  systemd.services.${app-name} = {
	    description = "The Forest Game Server";
		  wantedBy = [ "multi-user.target" ];
	  	after = [ "network.target" ];

	  	# Install the game before launching.
	  	#wants = [ "steam@${app-id}.service" ];
	  	#after = [ "steam@${app-id}.service" ];

	  	serviceConfig = {
	  	  User = app-name;
	  	  Group = app-name;
	  	  WorkingDirectory = "~";
		    Nice = "-5";
		    PrivateTmp = true;
		    Restart = "always";
		    RestartSec = 5;

		    
		    # should I be creating a /tmp folder inside the install directory to use for this?
		    Environment = ''
		      XDG_RUNTIME_DIR=${install-directory}
		    '';
		
		    # install the desired version of the game server, newest by default
		    ExecStartPre = ''
		      ${lib.getExe pkgs.steamcmd} \
		      +@sSteamCmdForcePlatformType windows \
					+login anonymous \
					+force_install_dir ${install-directory} \
					+app_update ${steam-app-id} \
					+quit
		  	'';
					
		  	ExecStart = "${x-virtual-framebuffer-run} ${wine-exe} ${server-exe} ${lib.concatStringsSep " " flags}";
		  };  	
  	};	
	};
}
