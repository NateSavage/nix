# This file (and the core directory) holds config that are used on all hosts
# If a package is not used on *every* host, it should go in the optional directory
{
  inputs,
  outputs,
  ...
}: {
  imports = [
      inputs.home-manager.nixosModules.home-manager
      #./acme.nix
      #./auto-upgrade.nix
      ../apps/fish.nix
      #./locale.nix
      #./nix.nix
      #./openssh.nix
      #./optin-persistence.nix
      #./podman.nix
      #./sops.nix
      #./ssh-serve-store.nix
      #./steam-hardware.nix
      ../apps/systemd-initrd.nix
      #./tailscale.nix
      #./gamemode.nix
      #./nix-ld.nix
      #./prometheus-node-exporter.nix
      #./kdeconnect.nix
      #./upower.nix
    ]

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # Fix for qt6 plugins
  # TODO: maybe upstream this?
  #environment.profileRelativeSessionVariables = {
  #  QT_PLUGIN_PATH = ["/lib/qt-6/plugins"];
  #};

  hardware.enableRedistributableFirmware = true;

  # Cleanup stuff included by default
  #services.speechd.enable = false;
}