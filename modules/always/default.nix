{ ...}: {
  imports = [
    ../feature-sets/nix-core.nix
    ../feature-sets/nix-utils.nix

    ../apps/fish.nix
    ../apps/just.nix
  ];

  boot.initrd.systemd.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  hardware.enableRedistributableFirmware = true;

  # Cleanup stuff included by default
  #services.speechd.enable = false;
}