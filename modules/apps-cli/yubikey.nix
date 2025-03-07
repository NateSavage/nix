{lib, nixpkgs, configVars, ... }:
{
  # set home directory for linux or macos
  let homeDirectory = if nixpkgs.stdenv.isLinux then "/home/${configVars.username}" else "/Users/${configVars.username}";
  in {
    environment.systemPackages = {
      inherit (nixpkgs)
        yubioath-flutter # gui tool
        yubikey-manager  # cli tool
        pam_u2f          # allows yukikey use for sudo
        ;
    };

    services.pcscd.enable = true; # smartcard service
    services.udev.packages = [ nixpkgs.yubikey-personalization ];
    services.yubikey-agent.enable = true;

    # yubikey login/sudo
    security.pam = lib.optionalAttrs nixpkgs.stdenv.isLinux {
      sshAgentAuth.enable = true;
      u2f {

      }
    }
  }
}