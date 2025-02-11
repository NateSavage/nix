# installed programs shared by all hosts
{
  imports = [
    ../feature-sets/nix-core.nix
    ../feature-sets/nix-utils.nix
    
	../feature-sets/linux-utils-core.nix 
  ];
}
