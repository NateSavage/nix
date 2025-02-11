{ config, ... }: {
  config = {  	
  	  programs.home-manager.enable = true;
  	  
  	  home = {
  	    username = "nate";
  	    homeDirectory = "/home/${config.home.username}";
  	    stateVersion = "24.05";
  	    sessionPath = ["$HOME"];
  	    sessionVariables = {
  	      FLAKE = "$HOME/Nix";
  	    };
  	  };
  };
}
