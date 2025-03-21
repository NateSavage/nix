# Basic tools I want on all linux systems
{ pkgs, ... } : {
	imports = [
	  ../apps-cli/superfile.nix
	  ../apps-cli/ion-shell.nix
	  ../apps-cli/just.nix
	];

  environment.systemPackages = [
    pkgs.micro
    pkgs.age
    pkgs.ssh-to-age
  ];
}
