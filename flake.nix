{
  description = "khakcsar - NixOS on Oracle Cloud A1";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, disko, ...}: {
    nixosConfigurations.khakcsar = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {
        pkgs-unstable = nixpkgs-unstable.legacyPackages.aarch64-linux;
      };
      modules = [
        disko.nixosModules.disko
        ./hosts/khakcsar
      ];
    };
  };
}
