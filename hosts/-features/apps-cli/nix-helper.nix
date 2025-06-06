# nh (yet another nix helper) https://github.com/viperML/nh

{ ... }: {

  config = {

    # nh requires nix-command and flakes, only add them if they aren't already enabled by another module?
    nix.settings.experimental-features = [ "nix-command" "flakes" ]; #lib.unique(experimentalFeatures);

     programs = {
      git.enable = true;  # nh will not run without git
      nh.enable = true;
    };
  };
}
