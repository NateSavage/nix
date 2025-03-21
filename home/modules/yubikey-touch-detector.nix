{ config, lib, pkgs, ... } : with lib;
let
cfg = config.services.yubikey-touch-detector;
in {
  options.services.yubikey-touch-detector = {

  };

  config = mkIf cfg.enable {

  };
}
