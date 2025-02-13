{ config, ... }: {


  networking.firewall = {
    enable = true;
  };
  
  services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        AllowUsers = [ "nate" ]; # Allows all users by default. Can be [ "user1" "user2" ]
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      };
    };
  
  # A unique Machine ID is stored in /var/lib/dbus/machine-id and on systemd systems, /etc/machine-id also. These should be edited to something generic, such as the Whonix ID:
  # b08dfa6083e7567a1921a715000001fb
  
  # make the kernel ignore ICMP requests?
  
  # brute force login slowdown
  # auth optional pam_faildelay.so delay=4000000
}
