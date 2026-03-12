{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common/core.nix
    ../common/security.nix
    ../common/desktop.nix
    ../../users/admin.nix
  ];

  networking.hostName = "beepbox";
  system.stateVersion = "25.05";

  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];
  
  yubikey.enable = true;

}
