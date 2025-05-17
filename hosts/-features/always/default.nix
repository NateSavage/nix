# system wide features shared by all hosts
#{ config, ... }: let
 # hostName = config.networking.hostName;
#in {
{
  imports = [
    ../../../modules
    #../../${hostName}/hardware-configuration.nix
    ./nix-core.nix
    ./nix-utils.nix
	  ./linux-utils.nix
  ];
  
   users.groups.home = {};
}
