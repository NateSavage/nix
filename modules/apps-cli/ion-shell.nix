# A fast and more sane shell I can write my scripts in
# https://gitlab.redox-os.org/redox-os/ion

{ pkgs, ... }: {
  config.environment.systemPackages = [
    pkgs.ion
  ];
}
