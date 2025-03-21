{ config, ... } : let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  secrets = config.sops.secrets;
  homeDirectory = /home/admin;
in {

  users.users.admin = {

    isNormalUser = true;

    #shell = nixpkgs.fish;

    hashedPassword="$y$j9T$u3miKRe0i9J4A0x4WRZxY/$nTZTaJlqQ9MWL/SGA5CJVAKFi0jhOHSriSVMswwkVm4";
    extraGroups = ifGroupsExist [
      "wheel"
    ];
  };


  home-manager.users.admin = {
    imports = [
      ../../home/admin/at/${config.networking.hostName}.nix
      #unstable-zed-editor
      #(inputs.home-manager-unstable + "modules/programs/zed-editor.nix")
    ];
  };
}
