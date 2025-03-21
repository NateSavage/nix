# you will need to include a flake to use this module
# https://github.com/lilyinstarlight/nixos-cosmic

{
  imports = [
    ./always.nix
  ];

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
}
