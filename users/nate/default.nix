{ inputs, lib, config, ... } : let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  secrets = config.sops.secrets;
  public-keys = lib.filesystem.listFilesRecursive ./keys;
in {

  users.users.nate = {

    isNormalUser = true;
    #shell = nixpkgs.fish;

    hashedPassword="$y$j9T$u3miKRe0i9J4A0x4WRZxY/$nTZTaJlqQ9MWL/SGA5CJVAKFi0jhOHSriSVMswwkVm4";
    extraGroups = ifGroupsExist [
      "synced"
      "wheel"
    ];

    # These get placed into /etc/ssh/authorized_keys.d/<name> on nixos
    openssh.authorizedKeys.keys = lib.lists.forEach public-keys (key: builtins.readFile key);

    #hashedPasswordFile = config.sops.secrets.nate-password.path;
    #packages = [
    #  nixpkgs.home-manager
    #];
  };

  # if the host system has our yubikey module enabled, add our keys
  yubikey = lib.mkIf config.yubikey.enable {
    identifiers = {
      a = 31114443;
      c = 27429156;
    };
  };


  services.openssh.settings.AllowUsers = [ "nate" ];

  #imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.secrets = {
    "users/nate/hashed-password" = {
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };

    # extract to default pam-u2f authfile location for passwordless sudo. see ../optional/yubikey
    "users/nate/yubico/u2f-keys" = {
      sopsFile = ./secrets.yaml;
      owner = config.users.users.nate.name;
      group = config.users.users.nate.group;
      path = "/home/nate/.config/Yubico/u2f_keys";
    };
  };

  home-manager.extraSpecialArgs = { inherit inputs; };
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
