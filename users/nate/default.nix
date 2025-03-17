{ config, ... } : let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {

  users.users.nate = {

    isNormalUser = true;
    #shell = nixpkgs.fish;
    hashedPassword="$y$j9T$u3miKRe0i9J4A0x4WRZxY/$nTZTaJlqQ9MWL/SGA5CJVAKFi0jhOHSriSVMswwkVm4";
    extraGroups = ifGroupsExist [
      "synced"
      "wheel"
    ];



    #openssh.authorizedKeys.keys = lib.splitString "\n" (builtins.readFile ../../../../home/nate/ssh.pub);
    #hashedPasswordFile = config.sops.secrets.nate-password.path;
    #packages = [
    #  nixpkgs.home-manager
    #];
  };

  services.openssh.settings.AllowUsers = [ "nate" ];

  #sops.secrets.nate-password = {
  #  sopsFile = ../../secrets.yaml;
  #  neededForUsers = true;
  #};


  home-manager.users.nate = {
    imports = [
      ../../home/nate/at/${config.networking.hostName}.nix
      #unstable-zed-editor
      #(inputs.home-manager-unstable + "modules/programs/zed-editor.nix")
    ];
  };
  #security.pam.services = {
  #  swaylock = {};
  #};
}
