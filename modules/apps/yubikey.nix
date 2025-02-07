{lib, pkgs, configVars, ... }:
{
  # set home directory for linux or macos
  let homeDirectory = if pkgs.stdenv.isLinux then "/home/${configVars.username}" else "/Users/${configVars.username}";
  in {
    environment.systemPackages = {
      inherit (pkgs)
        yubioath-flutter # gui tool
        yubikey-manager  # cli tool
        pam_u2f          # allows yukikey use for sudo
        ;
    };

    services.pcscd.enable = true; # smartcard service
    services.udev.packages = [ pkgs.yubikey-personalization ];
    services.yubikey-agent.enable = true;

    # yubikey login/sudo
    security.pam = lib.optionalAttrs pkgs.stdenv.isLinux {
      sshAgentAuth.enable = true;
      u2f {

      }
    }
  }
}