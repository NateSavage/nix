{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}: 
{


  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        #"ca-derivations"
      ];
      #warn-dirty = false;
    };
  };

  programs = {
    home-manager.enable = true;
  };

  home = {
    username = lib.mkDefault "nate";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "24.05";
    sessionPath = ["$HOME"];
    sessionVariables = {
      FLAKE = "$HOME/Nix";
  };
}