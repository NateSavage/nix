
{
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
    };
    
    # globally set .gitattributes
    #attributes = {
      
    #};
  };
}
