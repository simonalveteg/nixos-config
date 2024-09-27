{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }@inputs: {
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    nixosConfigurations = {
      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";        
        modules = [
          ./hosts/WSL/configuration.nix
          inputs.home-manager.nixosModules.default
	        nixos-wsl.nixosModules.wsl
        ];
      };
      c940 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = [
          ./hosts/C940/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
