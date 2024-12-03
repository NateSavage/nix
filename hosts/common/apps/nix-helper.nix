# nh (yet another nix helper) https://github.com/viperML/nh

{config, pkgs, lib, ...}: 
  let 
    nixHelperRequiredFeatures = [ "nix-command" "flakes" ];
    experimentalFeatures = config.nix.settings.experimental-features ++ [ "nix-command" "flakes" ];
    experimentalFeaturesAdded = config.nix.settings ? experimental-features;
in {

  # nh requires nix-command and flakes, only add them if they aren't already enabled by another module
  config = {

    # nh requires nix-command and flakes, only add them if they aren't already enabled by another module
    nix.settings.experimental-features = nixHelperRequiredFeatures; #lib.unique(experimentalFeatures);

    programs = {
      git.enable = true;  # nh will not run without git
      nh.enable = true;
    };
  };
}