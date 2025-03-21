{
  imports = [
    ./hardware-configuration.nix
    <nixos-wsl/modules>

    ../../modules/always
    ../../users/nate
  ];

  wsl.enable = true;
  wsl.defaultUser = "nate";

  networking = {
    hostName = "whisp";
  };

  # I think I want to move this outside of the host and into the flake at the top level
  system.stateVersion = "24.05";
}