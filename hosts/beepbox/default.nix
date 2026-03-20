{ pkgs, inputs, config, ... }: {
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

  nixpkgs.config.allowAliases = false;

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

  sops.secrets."openclaw.discord-token".owner = "localclaw";

  # ── LocalClaw ─────────────────────────────────────────────────────────────
  nixpkgs.overlays = [ inputs.local-claw.overlays.default ];

  services.localclaw = {
    enable       = true;
    serveGateway = "lan";
    acceleration = "cuda";
    modelBackend = "vllm";

    vllm = {
      model                = "Qwen/Qwen3.5-27B-GPTQ-Int4";
      servedModelName      = "Qwen3.5-27B";
      quantization         = "gptq";
      maxModelLen          = 40960;
      gpuMemoryUtilization = 0.92;
      languageModelOnly    = true;
      enablePrefixCaching  = true;
      reasoningParser      = "qwen3";
    };

    agents."martin" = {
      model   = "vllm/Qwen3.5-27B";
      name    = "Martin";
      default = true;
    };

    discord = {
      enable    = true;
      tokenFile = "/var/lib/localclaw/discord-bot-token";
    };
  };

}
