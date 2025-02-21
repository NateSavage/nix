{
  description = "Nate's personal NixOS mono-flake.";

  inputs = {
    # Nix ecosystem
    hardware.url = "github:nixos/nixos-hardware";
    systems.url = "github:nix-systems/default-linux";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";


    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    # Secrets Management
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

	# Additional flake dependencies
    impermanence.url = "github:misterio77/impermanence";
    superfile.url = "github:yorukot/superfile";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    systems,
    ...
  } @inputs: let
    inherit (self) outputs;
    # lib is a nix convention for where to helper functions
    lib = nixpkgs.lib // home-manager.lib;
    forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
  in {

    inherit lib;
    #nixosModules = import ./modules/nixos;
    #homeManagerModules = import ./modules/home-manager;
    #overlays = import ./overlays {inherit inputs outputs;};

    # Accessible through 'nix build', 'nix shell', etc
    #packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
    #devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {

      # Windows Subsystem for Linux playground.
      whisp = lib.nixosSystem {
        modules = [./hosts/whisp/configuration.nix];
        specialArgs = {inherit inputs outputs;};
      };

      ## Personal Server.
      nox = lib.nixosSystem {
        modules = [./hosts/nox/configuration.nix];
        specialArgs = {inherit inputs outputs;};
      };

      ## Personal Server.
      snek = lib.nixosSystem {
        modules = [./hosts/snek/configuration.nix];
        specialArgs = {inherit inputs outputs;};
      };

    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {

      "nate@whisp" = lib.homeManagerConfiguration {
        modules = [ ./home/nate/at/whisp.nix ];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
      };

      "nate@nox" = lib.homeManagerConfiguration {
        modules = [ ./home/nate/at/nox.nix ];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
      };

      "nate@snek" = lib.homeManagerConfiguration {
        modules = [ ./home/nate/at/snek.nix ];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
      };
    };
  };
}
