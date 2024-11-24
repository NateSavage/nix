{
  imports = [
    ./services
    ./hardware-configuration.nix

    ../common/core
    ../common/users/nate
  ];

  networking = {
    hostName = "nox";
    hostId = "b344a648";
  };
}