
{ config, pkgs, lib,... }:
let
  homeDirectory = if pkgs.stdenv.isLinux then "/home/nate" else "/Users/nate";
  # will be executed when a yubikey is plugged in
  yubikey-up =
  let
    yubikeyIds = lib.concatStringsSep " " (
      lib.mapAttrsToList (name: id: "[${name}]=\"${builtins.toString id}\"") config.yubikey.identifiers
    );
  in
  pkgs.writeShellApplication {
    name = "yubikey-up";
    runtimeInputs = builtins.attrValues { inherit (pkgs) gawk yubikey-manager; };
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      serial=$(ykman list | awk '{print $NF}')
      # If it got unplugged before we ran, just don't bother
      if [ -z "$serial" ]; then
        exit 0
      fi

      declare -A serials=(${yubikeyIds})

      key_name=""
      for key in "''${!serials[@]}"; do
        if [[ $serial == "''${serials[$key]}" ]]; then
          key_name="$key"
        fi
      done

      if [ -z "$key_name" ]; then
        echo WARNING: Unidentified yubikey with serial "$serial" . Won\'t link an SSH key.
        exit 0
      fi

      echo "Creating links to ${homeDirectory}/$key_name-ed25519-sk"
      ln -sf "${homeDirectory}/.ssh/$key_name-ed25519-sk" ${homeDirectory}/.ssh/id_yubikey
      ln -sf "${homeDirectory}/.ssh/$key_name-ed25519-sk.pub" ${homeDirectory}/.ssh/id_yubikey.pub
    '';
  };

  # will be executed when a yubikey is unpluggedi
  yubikey-down = pkgs.writeShellApplication {
      name = "yubikey-down";
      text = ''
          #!/usr/bin/env bash
          set -euo pipefail

          rm ${homeDirectory}/.ssh/id_yubikey
          rm ${homeDirectory}/.ssh/id_yubikey.pub
      '';
  };
in {
  options = {
    yubikey = {
      enable = lib.mkEnableOption "Enable yubikey support";
      identifiers = lib.mkOption {
        default = { };
        type = lib.types.attrsOf lib.types.int;
        description = "Attrset of Yubikey serial numbers";
        example = lib.literalExample ''
          {
            foo = 12345678;
            bar = 87654321;
          }
        '';
      };
    };
  };

  config = lib.mkIf config.yubikey.enable {

    environment.systemPackages = lib.flatten [
      (builtins.attrValues {
       inherit (pkgs)
          yubioath-flutter # gui-based authenticator tool. yubioath-desktop on older nixpkg channels
          yubikey-manager # cli-based authenticator tool. accessed via `ykman`

          pam_u2f # for yubikey with sudo
        ;
      })
      yubikey-up
      yubikey-down
    ];



    # Create ssh files
    # Yubikey 4/5 U2F+CCID
    # SUBSYSTEM == "usb", ATTR{idVendor}=="1050", ENV{ID_SECURITY_TOKEN}="1", GROUP="wheel"
    # We already have a yubikey rule that sets the ENV variable

    # This is linux only
    services.udev.extraRules = ''
      # Link/unlink ssh key on yubikey add/remove
      SUBSYSTEM=="usb", ACTION=="add", ATTR{idVendor}=="1050", RUN+="${lib.getBin yubikey-up}/bin/yubikey-up"
      # NOTE: Yubikey 4 has a ID_VENDOR_ID on remove, but not Yubikey 5 BIO, whereas both have a HID_NAME.
      # Yubikey 5 HID_NAME uses "YubiKey" whereas Yubikey 4 uses "Yubikey", so matching on "Yubi" works for both
      SUBSYSTEM=="hid", ACTION=="remove", ENV{HID_NAME}=="Yubico Yubi*", RUN+="${lib.getBin yubikey-down}/bin/yubikey-down"

      ##
      # Yubikey 4
      ##

      # Lock the device if you remove the yubikey (use udevadm monitor -p to debug)
      # #ENV{ID_MODEL_ID}=="0407", # This doesn't match all the newer keys
      # script that does smarter checks
      # ACTION=="remove",\
      #  ENV{ID_BUS}=="usb",\
      #  ENV{ID_VENDOR_ID}=="1050",\
      #  ENV{ID_VENDOR}=="Yubico",\
      #  RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"

      ##
      # Yubikey 5 BIO
      #
      # NOTE: The remove event for the bio doesn't include the ID_VENDOR_ID for some reason, but we can use the
      # hid name instead. Some HID_NAME might be "Yubico YubiKey OTP+FIDO+CCID" or "Yubico YubiKey FIDO", etc so just
      # match on "Yubico YubiKey"
      ##

      # lock session if yubikey unplugged
      SUBSYSTEM=="hid", ACTION=="remove", ENV{HID_NAME}=="Yubico YubiKey OTP+FIDO+CCID", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"

      # SUBSYSTEM=="hid", ACTION=="add", ENV{HID_NAME}=="Yubico YubiKey OTP+FIDO+CCID", RUN+="${pkgs.systemd}/bin/loginctl activate 1",\
      # RUN+="${lib.getBin pkgs.xorg.xset}/bin/xset dpms force on"
    '';

    # Yubikey required services and config. See Dr. Duh NixOS config for
    # reference
    services.pcscd.enable = true; # smartcard service
    services.udev.packages = [ pkgs.yubikey-personalization ];

    services.yubikey-agent.enable = true;

    # yubikey login / sudo
    security.pam = lib.optionalAttrs pkgs.stdenv.isLinux {
      sshAgentAuth.enable = true;
      u2f = {
        enable = true;
        settings = {
          cue = true; # Tells user they need to press the button
          authFile = "${homeDirectory}/.config/Yubico/u2f_keys";
        };
      };
      services = {
        login.u2fAuth = true;
        sudo = {
          u2fAuth = true;
          sshAgentAuth = true; # Use SSH_AUTH_SOCK for sudo
        };
      };
    };
  };
}
