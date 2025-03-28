# include this module in a host to require security key 2 factor on remotely connected users for actions like sudo

{ nixpkgs, outputs, lib, config, ... }: let

  hosts = lib.attrNames outputs.nixosConfigurations;

  # Sops needs acess to the keys before the persist dirs are even mounted; so
  # just persisting the keys won't work, we must point at /persist
  #hasOptinPersistence = config.environment.persistence ? "/persist";
in {

  # see security folder for hardening
  services.openssh = {
    enable = true;
    settings = {
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
      # Allow forwarding ports to everywhere
      GatewayPorts = "clientspecified";
      # Let WAYLAND_DISPLAY be forwarded
      # AcceptEnv = "WAYLAND_DISPLAY";
    };

    hostKeys = [
      {
        #path = "${lib.optionalString hasOptinPersistence "/persist"}/etc/ssh/ssh_host_ed25519_key";
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

   # yubikey login / sudo
  # NOTE: We use rssh because sshAgentAuth is old and doesn't support yubikey:
  # https://github.com/jbeverly/pam_ssh_agent_auth/issues/23
  # https://github.com/z4yx/pam_rssh
  security.pam.services.sudo =
    { config, ... }:
    {
      rules.auth.rssh = {
        order = config.rules.auth.ssh_agent_auth.order - 1;
        control = "sufficient";
        modulePath = "${nixpkgs.pam_rssh}/lib/libpam_rssh.so";
        settings.authorized_keys_command = nixpkgs.writeShellScript "get-authorized-keys" ''
          cat "/etc/ssh/authorized_keys.d/$1"
        '';
      };
    };
}
