# installed programs shared by all hosts
{
  imports = [
    ./nix-core.nix
    ./nix-utils.nix
	  ./linux-utils.nix
		# figure out how to import the hardware configuration file in here using the host name
  ];
}
