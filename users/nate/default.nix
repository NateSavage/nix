{config, ...}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  users.users.nate = {
    isNormalUser = true;
    #shell = nixpkgs.fish;
    hashedPassword="$y$j9T$u3miKRe0i9J4A0x4WRZxY/$nTZTaJlqQ9MWL/SGA5CJVAKFi0jhOHSriSVMswwkVm4";
    extraGroups = ifTheyExist [
      "audio"
      "docker"
      "git"
      "i2c"
      "libvirtd"
      "lxd"
      "mysql"
      "network"
      "plugdev"
      "podman"
      "video"
      "wheel"
      "wireshark"
    ];

    #openssh.authorizedKeys.keys = lib.splitString "\n" (builtins.readFile ../../../../home/nate/ssh.pub);
    #hashedPasswordFile = config.sops.secrets.nate-password.path;
    #packages = [
    #  nixpkgs.home-manager
    #];
  };

  #sops.secrets.nate-password = {
  #  sopsFile = ../../secrets.yaml;
  #  neededForUsers = true;
  #};

  home-manager.users.nate = import ../../home/nate/at/${config.networking.hostName}.nix;

  #security.pam.services = {
  #  swaylock = {};
  #};
}
