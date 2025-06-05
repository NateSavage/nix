{ config, ... } :  let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {

  imports = [
    ./hardware-configuration.nix
    ../-features/always

    ../-features/security/nix-hardening.nix

    ../../users/nate
  ];

  jovian.steam.enable = true;
  jovian.steam.autoStart = true;
  jovian.steam.updater.splash = "jovian";
  jovian.steam.desktopSession = "cosmic";
  jovian.steam.user = "games";
  jovian.hardware.has.amd.gpu = true;

  programs.steam = {
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  users.users.games = {

    isNormalUser = true;

    extraGroups = ifGroupsExist [
      "anyone"
    ];
  };

  services.desktopManager.cosmic.enable = true;
  #services.displayManager.cosmic-greeter.enable = true;
  
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "games";

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  networking = {
    hostName = "gamebox";
    #hostId = "b344a648";
  };

  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # this device doesn't have enough ram to do a large compilation without running out of memory
  # more swap space helps somewhat
  #swapDevices = [{
  #  device = "/swapfile";
  #  size = 16 * 1024; # 16GB
  #}];
  system.stateVersion = "25.11";
}
