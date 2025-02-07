
# default recipe to display help information
default:
  @just --list

switch-to host-name:
  nh os switch ./ -- hostname {{host-name}} --extra-experimental-features nix-command --extra-experimental-features flakes

# updates contents of flake.lock file, builds, and switches to the fresh OS until reboot
tryout-update host-name:
  nh os test ./ -- update hostname {{host-name}} --extra-experimental-features nix-command --extra-experimental-features flakes

# updates contents of flake.lock file, builds, and switches to the fresh OS while setting it as the default
update host-name:
  # TODO: accept hostname as an argument, if it's whisp we need to add "-- --impure" to the end of the command
  nh os switch ./ -- update hostname {{host-name}} --extra-experimental-features nix-command --extra-experimental-features flakes



# sync USER HOST:
#  rsync -av --filter=':- .gitignore' -e "ssh -l {{USER}}" . {{USER}}@{{HOST}}:nix-config/