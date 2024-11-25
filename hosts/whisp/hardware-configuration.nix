
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "virtio_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/lib/modules/5.15.153.1-microsoft-standard-WSL2" =
    { device = "none";
      fsType = "overlay";
    };

  fileSystems."/mnt/wsl" =
    { device = "none";
      fsType = "tmpfs";
    };

  fileSystems."/usr/lib/wsl/drivers" =
    { device = "drivers";
      fsType = "9p";
    };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b1d825c2-729a-4998-97be-92fe193234f0";
      fsType = "ext4";
    };

    fileSystems."/mnt/wslg" =
    { device = "none";
      fsType = "tmpfs";
    };

  fileSystems."/mnt/wslg/distro" =
    { device = "";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/usr/lib/wsl/lib" =
    { device = "none";
      fsType = "overlay";
    };

  fileSystems."/tmp/.X11-unix" =
    { device = "/mnt/wslg/.X11-unix";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/mnt/wslg/doc" =
    { device = "none";
      fsType = "overlay";
    };

  fileSystems."/mnt/c" =
    { device = "C:\134";
      fsType = "9p";
    };

  fileSystems."/mnt/e" =
    { device = "E:\134";
      fsType = "9p";
    };

  fileSystems."/mnt/f" =
    { device = "F:\134";
      fsType = "9p";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/8a7d19d9-2a5a-4903-b28b-454dcc626696"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}