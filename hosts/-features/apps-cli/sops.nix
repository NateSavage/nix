# Mozilla Secret OPerationS
# requires input at the top of the flake
# Do not run sops as root! It will look for keys in the wrong location and won't be able to decrypt anything
#
{ inputs, pkgs, config, ... }: let
  isEd25519 = k: k.type == "ed25519";
  getKeyPath = k: k.path;
  keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = [ pkgs.sops ];

  sops = {

    defaultSopsFile = ../security/secrets.yaml;
    validateSopsFiles = true;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };



    secrets = {

      org-url = {
        # sopsFile = ../security/secrets.yaml; # file for secret can be definined individually
        # path = "${config.sops.defaultSymlinkPath}/org-url";
      };

      #msmtp-host = { };
      #msmtp-address = { };
      #msmtp-password = { };
    };
  };
}
