# This file holds config that are used on all hosts

{inputs, outputs, ...}: {
  imports = [
    ../feature-sets/nix-core.nix
    ../apps/fish.nix

  ];

  nix.settings.experimental-features = "nix-command flakes";

  boot.initrd.systemd.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  hardware.enableRedistributableFirmware = true;

  # Cleanup stuff included by default
  #services.speechd.enable = false;
}