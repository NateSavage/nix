# a fork of gitea, open source software forge
# note, eaxh host should define netports and pass them down to imported modules
{ pkgs, ... } :
let
  domain = "ohboy";
  rootDomain = "git";
  httpPort = 3000;
  
  # DISABLE_HTTP_GIT: false: Disable the ability to interact with repositories over the HTTP protocol.
in
{

  services.forgejo.enable = true;
  services.forgejo.package = pkgs.forgejo-lts;

  # OS
  users.groups.forge = { };
  services.forgejo = {
    user = "forgejo";
    group = "forge";
  };
  
  
  # network
  networking.firewall.allowedTCPPorts = [ httpPort ];
  services.forgejo.settings.server  = {
    DOMAIN = "0.0.0.0"; # "git.panopticom.online";
    
    # You need to specify this to remove the port from URLs in the web UI.
    #ROOT_URL = "https://${srv.DOMAIN}/"; 
    HTTP_PORT = httpPort;
  };
  
  
  # storage
  services.forgejo = {
     stateDir = "/var/lib/forgejo"; # "/var/lib/forgejo" by default
     # lfs.contentDir = ; "${config.services.forgejo.stateDir}/data/lfs" by default
     settings.log.LEVEL = "Debug";
  };
  
  
  # configuration
  services.forgejo = {
  
    # git settings
    lfs.enable = true;
    
    # forgejo server settings
    settings = {
      
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true; 
      
      # Add support for actions, based on act: https://github.com/nektos/act
      actions = {
        #ENABLED = true;
        # DEFAULT_ACTIONS_URL = "github";
      };
    };
  }; 
}
