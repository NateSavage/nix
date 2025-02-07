{
  imports = [
    ./hardware-configuration.nix

    ../../modules/always
    ../../users/nate
  ];

  networking = {
    hostName = "nox";
    hostId = "b344a648";
  };
}