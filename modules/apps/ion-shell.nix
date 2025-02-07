# https://gitlab.redox-os.org/redox-os/ion
{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.ion
  ];
}