{
  imports = [
    ./hardware-configuration.nix

    ../common/required
    ../../users/nate

    <nixos-wsl/modules>

    ../common/apps/kde-plasma-6.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "nate";

  networking = {
    hostName = "whisp";
  };
}