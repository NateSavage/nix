# https://gitlab.redox-os.org/redox-os/ion
{ nixpkgs, ... }: {
  environment.systemPackages = [
    nixpkgs.ion
  ];
}