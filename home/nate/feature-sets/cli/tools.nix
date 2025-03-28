{
  imports = [
	  ../../apps/micro.nix
	  ../../apps/git.nix
  ];

  programs.neovim.enable = true;
  #programs.micro.enable = true;
  #programs.micro.isDefaultEditor = true;

}
