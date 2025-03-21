# NixOS settings I like to have across all systems
{
  imports = [
    ../apps-cli/home-manager.nix
    #../opt-in-persistence.nix
  ];
  config = {
    nixpkgs.config.allowUnfree = true;
    boot.initrd.systemd.enable = true;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    hardware.enableRedistributableFirmware = true;

    # Enable networking
    networking.networkmanager.enable = true;

    # See https://jackson.dev/post/nix-reasonable-defaults/
    nix.settings = {
     experimental-features = [ "nix-command" "flakes" ];

      # The timeout (in seconds) for establishing connections in the binary cache substituter. It corresponds to curl’s –connect-timeout option. A value of 0 means no limit.
      connect-timeout = 5;

      # The number of lines of the tail of the log to show if a build fails.
      log-lines = 50;

      # When free disk space in /nix/store drops below min-free during a build,
      # Nix performs a garbage-collection until max-free bytes are available or there is no more garbage.
      # A value of 0 (the default) disables this feature.
      min-free = 128000000; # 128MB
      max-free = 1000000000; # 1GB
      # Note: These are actually most useful if you setup /nix on it’s own partition,


      # as long as you give it enough space then you never need to manually garbage collect.
      # Deduplicate and optimize nix store
      auto-optimise-store = true;

      # warn about dirty git/mercurial trees
      warn-dirty = false;
    };

    # Cleanup stuff included by default
    # text to speech service
    #services.speechd.enable = false;
  };


  # Garbage Collection
    #    gc = {
    #      automatic = true;
    #      options = "--delete-older-than 90d";
    #    };
}
