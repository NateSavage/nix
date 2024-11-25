# This file holds config that are used on all hosts
{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../apps/fish.nix
    ../apps/nix-helper.nix
  ];

  nix.settings.experimental-features = "nix-command flakes";

  boot.initrd.systemd.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  hardware.enableRedistributableFirmware = true;

  # Cleanup stuff included by default
  #services.speechd.enable = false;
}