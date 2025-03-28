
# default recipe to display help information
default:
    @just --list

test host-name: _ensure-all-files-in-git
    nh os test ./ --hostname {{host-name}} --verbose -- --extra-experimental-features nix-command --extra-experimental-features flakes

switch-os host-name: _ensure-all-files-in-git
    nh os switch ./ --hostname {{host-name}} -- --extra-experimental-features nix-command --extra-experimental-features flakes

# updates contents of flake.lock file, builds, and switches to the fresh OS until reboot
tryout-update host-name: _ensure-all-files-in-git
    nh os test ./ -- update hostname {{host-name}} --extra-experimental-features nix-command --extra-experimental-features flakes

# updates contents of flake.lock file, builds, and switches to the fresh OS while setting it as the default
update host-name: _ensure-all-files-in-git
    # TODO: accept hostname as an argument, if it's whisp we need to add "-- --impure" to the end of the command
    nh os switch ./ -- update hostname {{host-name}} --extra-experimental-features nix-command --extra-experimental-features flakes

build-home host-name: _ensure-all-files-in-git
    home-manager --flake .#nate@{{host-name}} build --extra-experimental-features nix-command --extra-experimental-features flakes

switch-home host-name: _ensure-all-files-in-git
    home-manager --flake .#nate@{{host-name}} switch -b backup --extra-experimental-features nix-command  --extra-experimental-features flakes --impure

#
# secrets and cryptography
#
# generates an age key for this host using the ssh key stored at /etc/ssh/ssh_host_ed25519_key.pub
get-age-public-key:
    nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'

# re-encrypts all secrets using the cluster's approved keys in the .sops.yaml file
update-secrets:
    nix-shell -p sops --run 'sops updatekeys ./hosts/-features/security/secrets.yaml ./hosts/-features/services/syncthing/secrets.yaml ./users/nate/secrets.yaml'


#
# private methods
#
_ensure-all-files-in-git:
  sudo git config --global --add safe.directory /etc/nixos
  sudo git add -A

# sync USER HOST:
#  rsync -av --filter=':- .gitignore' -e "ssh -l {{USER}}" . {{USER}}@{{HOST}}:nix-config/
