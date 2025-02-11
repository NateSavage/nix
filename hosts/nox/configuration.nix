{ pkgs, ...}: {
  imports = [
    ../always
    ./hardware-configuration.nix

    ../../modules/always
    ../../users/nate
  ];

  i18n.defaultLocale = "en_AU.UTF-8";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ "nate" ]; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };
  

  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    mirroredBoots = [
      { devices = [ "nodev"]; path = "/boot"; }
    ];
  };

  #ZFS
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [ "archive" ];
  services.zfs.autoScrub.enable = true;

  networking = {
    hostName = "nox";
    hostId = "b344a648";
  };

  system.stateVersion = "24.05";
}
