{ lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common/core.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "nates";

  networking.hostName = "whisp";
  system.stateVersion = "24.05";

  # YubiKey is not available inside WSL
  yubikey.enable = lib.mkForce false;
}
