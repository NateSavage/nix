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

    models."martin-reasoning" = {
      source        = "hf.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF:Q4_K_M";
      contextLength = 262144;
      temperature   = 1.0;
      topP          = 0.95;
      topK          = 20;
      minP          = 0.0;
      repeatPenalty = 1.0;
    };

    agents."martin" = {
      model   = "ollama/martin-reasoning";
      name    = "Martin";
      default = true;
    };

    discord = {
      enable    = true;
      tokenFile = config.sops.secrets."openclaw.discord-token".path;
    };
  };

}
