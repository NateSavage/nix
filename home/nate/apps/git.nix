{ config, ... }: let
   publicKey = "${config.home.homeDirectory}/.ssh/id_yubikey.pub";
in {
  programs.git = {
    enable = true;
    userName  = "Nate Savage";
    userEmail = "Nate.Savage@Panopticom.online";
    #signing = {
    #  signByDefault = true;
    #  key = "";
    #};

    # Large File Storage
    lfs.enable = true;

    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
      log.showSignature = "true";

      url = {
        "ssh://git@github.com" = {insteadOf = "https://github.com";};
        "ssh://git@gitlab.com" = {insteadOf = "https://gitlab.com";};
      };
    };

    # globally set .gitattributes
    #attributes = {

    #};
  };
}
