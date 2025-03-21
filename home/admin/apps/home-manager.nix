{ config, ... }: {
  config = {
  	  programs.home-manager.enable = true;

  	  home = {
  	    username = "admin";
  	    homeDirectory = "/home/${config.home.username}";
  	    sessionPath = ["$HOME"];
  	    sessionVariables = {
  	      FLAKE = "$HOME/Nix";
  	    };
        stateVersion = "25.05";
  	  };
  };
}
