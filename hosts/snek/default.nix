{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../-features/always
    ../-features/desktops/cosmic.nix

    ../-features/security/nix-hardening.nix

    ../../users/nate
    ../../users/admin

    ../-features/services/syncthing/client.nix
  ];

  yubikey.enable = true;

  environment.systemPackages = [

    pkgs.unityhub

  ];

  hardware.nvidia = {
    modesetting.enable = true; # required to be able to change any nvidia hardware settings
    nvidiaSettings = true;
  };

  # silly fix for unity hub sign in issue on 3/20/2025
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  system.stateVersion = "25.05";

  networking = {
    hostName = "snek";
    #hostId = "b344a648";
  };

  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # this device doesn't have enough ram to do a large compilation without running out of memory
  # more swap space helps somewhat
  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024; # 16GB
  }];
}
