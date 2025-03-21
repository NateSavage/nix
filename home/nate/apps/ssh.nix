{ lib, ... }:
let
  pathtokeys = ../../../users/nate/keys;
  yubikeys = lib.lists.forEach (builtins.attrNames (builtins.readDir pathtokeys))
      # Remove the .pub suffix
    (key: lib.substring 0 (lib.stringLength key - lib.stringLength ".pub") key);
  yubikeyPublicKeyEntries = lib.attrsets.mergeAttrsList (
    lib.lists.map
      # list of dicts
      (key: { ".ssh/${key}.pub".source = "${pathtokeys}/${key}.pub"; })
      yubikeys
  );
in {
  programs.ssh = {
    enable = true;

    controlMaster = "auto";
    controlPath = "~/.ssh/sockets/S.%r@%h:%p";
    controlPersist = "10m";

    matchBlocks = {
      "git" = {
        host = "gitlab.com github.com";
        user = "git";
        identityFile = [
          "~/.ssh/id_yubikey" # This is an auto symlink to whatever yubikey is plugged in. See hosts/common/optional/yubikey
          "~/.ssh/id_manu" # fallback to id_manu if yubis aren't present
        ];
      };
    };

    # req'd for enabling yubikey-agent
    extraConfig = ''
      AddKeysToAgent yes
    '';

  };
  home.file = {
    ".ssh/sockets/.keep".text = "# Managed by Home Manager";
  } // yubikeyPublicKeyEntries;
}
