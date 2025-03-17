{ config, ... }: {
  config = {
  	  programs.home-manager.enable = true;

  	  home = {
  	    username = "nate";
  	    homeDirectory = "/home/${config.home.username}";
  	    sessionPath = ["$HOME"];
  	    sessionVariables = {
  	      FLAKE = "$HOME/Nix";
  	    };
        stateVersion = "25.05";
  	  };
  };
}
