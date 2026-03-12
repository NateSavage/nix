{ config, ... }: {
  users.users.admin = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$u3miKRe0i9J4A0x4WRZxY/$nTZTaJlqQ9MWL/SGA5CJVAKFi0jhOHSriSVMswwkVm4";
    extraGroups = builtins.filter (g: builtins.hasAttr g config.users.groups) [ "wheel" ];
  };
}
