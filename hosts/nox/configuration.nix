{
  imports = [
    ./hardware-configuration.nix

    ../../modules/always
    ../../users/nate
  ];

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
}