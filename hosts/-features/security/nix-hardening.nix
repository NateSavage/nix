{
  imports = [
    ../apps-cli/sops.nix
  ];

  ##########################
  # System Security
  #

  # kernel
  # make the kernel ignore ICMP requests?

  # users
  users.mutableUsers = false;
  # require second factor security key for sudo
  security.pam.services.sudo.u2fAuth = true;

  # login
  # require second factor security key for login
  security.pam.services.login.u2fAuth = true;
  # brute force login slowdown
  # auth optional pam_faildelay.so delay=4000000

  ##########################
  # Network Security
  #
  networking.firewall = {
    enable = true;
  };

  services.openssh = {
    # todo: allow only known hosts in the cluster to ssh
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
        UseDns = true;
        X11Forwarding = false;
      };
    };

  # A unique Machine ID is stored in /var/lib/dbus/machine-id and on systemd systems, /etc/machine-id also. These should be edited to something generic, such as the Whonix ID:
  # b08dfa6083e7567a1921a715000001fb

}
