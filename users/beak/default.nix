{config, ...}: {
  imports = [./packages.nix];

  users.mutableUsers = false;
  users.users.beak = {
    isNormalUser = true;
    extraGroups = [
      "home"
    ];
   # hashedPasswordFile = config.sops.secrets.beak-password.path;
  };

  #sops.secrets.beak-password = {
  #  sopsFile = ../../secrets.yaml;
  #  neededForUsers = true;
  #};
}
