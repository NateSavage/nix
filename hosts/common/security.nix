# Security hardening for physical machines (not WSL)
{ pkgs, ... }: {
  # Immutable users — all accounts are defined in Nix, not /etc/passwd
  users.mutableUsers = false;

  # Require YubiKey touch for sudo and login (PAM U2F)
  security.pam.services.sudo.u2fAuth = true;
  security.pam.services.login.u2fAuth = true;

  networking.firewall.enable = true;

  # sops-nix: derive age key from SSH host ed25519 key
  environment.systemPackages = [ pkgs.sops ];
  sops.age = {
    sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    keyFile = "/var/lib/sops-nix/key.txt";
    generateKey = true;
  };

  services.openssh.settings = {
    PasswordAuthentication = false;
    PermitRootLogin = "no";
  };
}
