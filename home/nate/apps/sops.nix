{ inputs, config, ... }:
let
  secretsDirectory = ../../../users/nate;
  secretsFile = "${secretsDirectory}/secrets.yaml";
  homeDirectory = config.home.homeDirectory;
in {
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    # This is the location of the host specific age-key for ta and will to have been extracted to this location via hosts/common/core/sops.nix on the host
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";

    defaultSopsFile = "${secretsFile}";
    validateSopsFiles = false;

    secrets = {
      "users/nate/security-keys/a/public-key"  = { };
      "users/nate/security-keys/a/private-key" = {
        path = "${homeDirectory}/.ssh/a-ed25519-sk";
      };
      "users/nate/security-keys/c/public-key"  = { };
      "users/nate/security-keys/c/private-key" = {
        path = "${homeDirectory}/.ssh/c-ed25519-sk";
      };
    };
  };
}
