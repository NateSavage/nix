{inputs, pkgs, ...}: {
  imports = [
    ../apps/home-manager.nix
    #../opt-in-persistence.nix
  ];

  nix.settings = {
    # See https://jackson.dev/post/nix-reasonable-defaults/
    connect-timeout = 5;
    log-lines = 25;
    min-free = 128000000; # 128MB
    max-free = 1000000000; # 1GB
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    warn-dirty = false;
  };

  # Garbage Collection
    # Disabled here in favor of using nh based gc.
    #    gc = {
    #      automatic = true;
    #      options = "--delete-older-than 10d";
    #    };
}