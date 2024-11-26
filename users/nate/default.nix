{
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  users.users.nate = {
    isNormalUser = true;
    shell = pkgs.fish;
    hashedPassword="";
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
    packages = [
      pkgs.home-manager
    ];
  };

  #sops.secrets.nate-password = {
  #  sopsFile = ../../secrets.yaml;
  #  neededForUsers = true;
  #};

  home-manager.users.nate = import ../../home/nate/on/${config.networking.hostName}.nix;

  #security.pam.services = {
  #  swaylock = {};
  #};
}