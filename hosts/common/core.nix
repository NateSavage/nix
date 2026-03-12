# Settings shared by all hosts (safe for all platforms including WSL)
{
  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    connect-timeout = 5;
    log-lines = 50;
    min-free = 128000000;   # 128MB
    max-free = 1000000000;  # 1GB
    auto-optimise-store = true;
    warn-dirty = false;
  };

  # Groups used by the nate user module
  users.groups.home = {};
  users.groups.anyone = {};
  users.users.anyone = {
    isSystemUser = true;
    group = "anyone";
  };
}
