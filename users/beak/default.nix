{config, ...}: {
  imports = [./packages.nix];

  users.mutableUsers = false;
  users.users.beak = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ];
    hashedPasswordFile = config.sops.secrets.beak-password.path;
  };

  sops.secrets.beak-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  # Persist entire home
  environment.persistence = {
    "/persist".directories = ["/home/beak"];
  };
}