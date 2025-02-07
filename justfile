
# default recipe to display help information
default:
  @just --list


# updates contents of flake.lock file, builds, and switches to the fresh OS until reboot
tryout-flake-update:
  nh os test --update --hostname whisp ./flake.nix

# updates contents of flake.lock file, builds, and switches to the fresh OS while setting it as the default
flake-update:
  # TODO: accept hostname as an argument, if it's whisp we need to add "-- --impure" to the end of the command
  nh os switch --update --hostname whisp ./flake.nix



# sync USER HOST:
#  rsync -av --filter=':- .gitignore' -e "ssh -l {{USER}}" . {{USER}}@{{HOST}}:nix-config/