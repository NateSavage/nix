default:
    @just --list

# Switch the local machine (run on the machine itself)
switch: _ensure-git
    nh os switch ./

# Build and test locally without setting as default boot entry
test: _ensure-git
    nh os test ./

# Deploy to a remote host over SSH — builds locally, activates remotely
# Usage: just deploy beepbox   or   just deploy snek
deploy host-name: _ensure-git
    nixos-rebuild switch --flake .#{{host-name}} --target-host nates@{{host-name}}

# Update all flake inputs, then deploy
update host-name: _ensure-git
    nix flake update
    nixos-rebuild switch --flake .#{{host-name}} --target-host nates@{{host-name}}

# Get the age public key for the current host (run on the target machine after install)
# Add the output to .sops.yaml, then run: just update-secrets
get-age-key:
    ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub

# Re-encrypt secrets after updating .sops.yaml with new keys
update-secrets:
    sops updatekeys secrets/syncthing.yaml
    sops updatekeys hosts/beepbox/secrets.yaml

_ensure-git:
    sudo git config --global --add safe.directory /etc/nixos
    sudo git add -A
