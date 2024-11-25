{
  imports = [
    ./services
    ./hardware-configuration.nix

    ../common/core
    ../../users/nate
  ];

  networking = {
    hostName = "nox";
    hostId = "b344a648";
  };
}