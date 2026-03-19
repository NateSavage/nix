{
  description = "Nate's personal machines.";

  inputs = {
    # Pin nixpkgs to cosmic's version to avoid duplicate stores

    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix.url = "github:mic92/sops-nix";

    # User flake: provides nixosModules.nate-desktop and nate-server
    nixos-user = {
      url = "github:NateSavage/nixos-user";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    local-claw = {
      url = "github:NateSavage/local-claw";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, sops-nix, nixos-user, nixos-wsl, local-claw, ... } @ inputs: {

    nixosConfigurations = {

      # Desktop (AMD CPU + NVIDIA GPU)
      beepbox = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/beepbox
          sops-nix.nixosModules.sops
          nixos-user.nixosModules.nate-desktop
          local-claw.nixosModules.default
          { nixpkgs.overlays = [ local-claw.overlays.default ]; }
          {
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

              #models."martin-coding" = {
              #  source        = "hf.co/Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-GGUF:Q4_K_M";
              #  contextLength = 262144;
              #  temperature   = 1.0;
              #  topP          = 0.95;
              #  topK          = 20;
              #  minP          = 0.0;
              #  repeatPenalty = 1.0;
              #};
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };

      # Laptop (Intel CPU + NVIDIA GPU)
      snek = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/snek
          sops-nix.nixosModules.sops
          nixos-user.nixosModules.nate-desktop
        ];
        specialArgs = { inherit inputs; };
      };

      # WSL2 on Windows
      whisp = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/whisp
          nixos-wsl.nixosModules.default
          nixos-user.nixosModules.nate-server
        ];
        specialArgs = { inherit inputs; };
      };

    };

  };
}
