{
  description = "Nate's personal machines.";

  inputs = {
    # Pin nixpkgs to cosmic's version to avoid duplicate stores
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixpkgs.follows = "nixos-cosmic/nixpkgs";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # User flake: provides nixosModules.nate-desktop and nate-server
    nixos-user = {
      url = "github:NateSavage/nixos-user";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
      inputs.nixos-cosmic.follows = "nixos-cosmic";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix, nixos-user, nixos-wsl, ... } @ inputs: {

    nixosConfigurations = {

      # Desktop (AMD CPU + NVIDIA GPU)
      beepbox = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/beepbox
          sops-nix.nixosModules.sops
          nixos-user.nixosModules.nate-desktop
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
