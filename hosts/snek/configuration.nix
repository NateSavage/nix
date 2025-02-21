{ config, pkgs, ...}: {
  imports = [
    ../always
    ./hardware-configuration.nix

    ../../modules/always
    ../../modules/feature-sets/nix-hardening.nix
    #../../modules/apps/file-shelter.nix
    ../../users/nate
  ];

users.mutableUsers = false;
  users.users.user = {
    isNormalUser = true;
    #shell = nixpkgs.fish;
    hashedPassword="$y$j9T$u3miKRe0i9J4A0x4WRZxY/$nTZTaJlqQ9MWL/SGA5CJVAKFi0jhOHSriSVMswwkVm4";
    extraGroups = [
      "wheel"
    ];
};

  boot.loader.grub = {
    enable = true;
    #zfsSupport = true;
    efiSupport = true;
    mirroredBoots = [
      { devices = [ "nodev"]; path = "/boot"; }
    ];
  };
  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Cinnamon Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "nate";

  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
   #zed-editor
    gitkraken
  ];

}
