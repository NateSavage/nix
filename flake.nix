{
  description = "Nate's personal NixOS configurations. Forked from Misterio77's flake.";

  inputs = {
    # Nix exosystem
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:misterio77/impermanence";

    superfile.url = "github:yorukot/superfile";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    systems,
    ...
  } @ inputs: let
    inherit (self) outputs;
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
        modules = [./hosts/whisp];
        specialArgs = {inherit inputs outputs;};
      };

      ## Personal machine.
      #bbox = lib.nixosSystem {
      #  modules = [./hosts/bbox];
      #  specialArgs = {inherit inputs outputs;};
      #};
#
      ## Personal Server.
      #nox = lib.nixosSystem {
      #   modules = [./hosts/nox];
      #  specialArgs = {inherit inputs outputs;};
      #};
#
      ## Reverse proxy server.
      #guardian = lib.nixosSystem {
      #   modules = [./hosts/guardian];
      #  specialArgs = {inherit inputs outputs;};
      #};
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {

      "nate@whisp" = lib.homeManagerConfiguration {
        modules = [ ./home/nate/on/whisp.nix ];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
      };
      
    };
  };
}
