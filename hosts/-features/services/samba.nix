{ pkgs, ... } : {
  
  services.samba.enable = true;
  services.samba = {
    openFirewall = true;
    settings = {
      
    }
  }
}
