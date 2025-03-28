# a fork of gitea, open source software forge
# note, eaxh host should define netports and pass them down to imported modules
{ pkgs, ... } : {
  
  users.groups.forge = { };
  services.forgejo.enable = true;
  services.forgejo = {
  
    user = "forgejo";
    group = "forge";
    stateDir = "/var/lib/forgejo"; # "/var/lib/forgejo" by default
    package = pkgs.forgejo-lts;
    
    database.type = "sqlite3";
    # Enable support for Git Large File Storage
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = "0.0.0.0"; # "git.panopticom.online";
        # You need to specify this to remove the port from URLs in the web UI.
        #ROOT_URL = "https://${srv.DOMAIN}/"; 
        HTTP_PORT = 3000;
      };
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true; 
      # Add support for actions, based on act: https://github.com/nektos/act
      actions = {
        #ENABLED = true;
        # DEFAULT_ACTIONS_URL = "github";
      };
      # Sending emails is completely optional
      # You can send a test email from the web UI at:
      # Profile Picture > Site Administration > Configuration >  Mailer Configuration 
      #mailer = {
      #  ENABLED = true;
      #  SMTP_ADDR = "mail.example.com";
       #   FROM = "noreply@${srv.DOMAIN}";
      #    USER = "noreply@${srv.DOMAIN}";
     #   };
    };
    #mailerPasswordFile = config.age.secrets.forgejo-mailer-password.path;
  }; 
}
