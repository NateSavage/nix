{
  imports = [
    ./hardware-configuration.nix

    ../common/required
    ../../users/nate

    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nate";

  networking = {
    hostName = "whisp";
  }
}