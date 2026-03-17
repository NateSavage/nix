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

    openclaw-nix = {
      url = "github:NateSavage/openclaw-nix-localhost";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix, nixos-user, nixos-wsl, openclaw-nix, ... } @ inputs: {

    nixosConfigurations = {

      # Desktop (AMD CPU + NVIDIA GPU)
      beepbox = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/beepbox
          sops-nix.nixosModules.sops
          nixos-user.nixosModules.nate-desktop
          openclaw-nix.nixosModules.default
          openclaw-nix.nixosModules.ollama
          ({ config, pkgs, ... }: {
            sops.secrets."openclaw/discord-token" = {
              sopsFile = ./hosts/beepbox/secrets.yaml;
              owner = "openclaw";
              group = "openclaw";
            };

            services.openclaw = {
              enable = true;
              package = openclaw-nix.packages.${pkgs.stdenv.hostPlatform.system}.openclaw;
              domain = "";        # HAProxy on nox handles TLS — no Caddy needed
              openFirewall = false;
              extraGatewayConfig = {
                host = "0.0.0.0"; # bind to LAN so HAProxy can reach it
              };
              ollama = {
                enable = true;
                acceleration = "cuda";
              };
              discord = {
                enable = true;
                tokenFile = config.sops.secrets."openclaw/discord-token".path;
              };
            };

            networking.firewall.allowedTCPPorts = [ 3000 ];

            # AF_NETLINK is needed by Node.js getifaddrs() to enumerate network interfaces
            systemd.services.openclaw-gateway.serviceConfig.RestrictAddressFamilies = [
              "AF_INET" "AF_INET6" "AF_UNIX" "AF_NETLINK"
            ];
          })
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
