{ pkgs, inputs, config, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common/core.nix
    ../common/security.nix
    ../common/desktop.nix

    ../../users/nate

    ../../users/admin.nix
  ];

  networking.hostName = "beepbox";
  system.stateVersion = "25.05";

  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

  yubikey.enable = true;

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  # Never sleep or suspend
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';
  services.logind.extraConfig = ''
    HandleSuspendKey=ignore
    HandleLidSwitch=ignore
    HandleLidSwitchExternalPower=ignore
    IdleAction=ignore
  '';

  # ── Secrets ───────────────────────────────────────────────────────────────
  sops.defaultSopsFile = ./secrets.yaml;

  # ── LocalClaw ─────────────────────────────────────────────────────────────
  nixpkgs.overlays = [ inputs.local-claw.overlays.default ];

  services.localclaw = {
    enable       = true;
    serveGateway = "lan";
    acceleration = "cuda";
    modelBackend = "vllm";
    adminUsers    = [ "nates" ];
    extraPackages = with pkgs; [ go ripgrep fd ];

    vllm = {
      model                = "QuantTrio/Qwen3.5-9B-AWQ";
      servedModelName      = "Qwen3.5-9B";
      quantization         = "awq_marlin";
      maxModelLen          = 32768;
      gpuMemoryUtilization = 0.92;
      enablePrefixCaching  = true;
      reasoningParser      = "qwen3";
    };

    agents."martin" = {
      model   = "vllm/Qwen3.5-9B";
      name    = "Martin";
      default = true;
    };

  };

  # ── n8n ───────────────────────────────────────────────────────────────────
  services.n8n = {
    enable      = true;
    openFirewall = true;
  };

}
