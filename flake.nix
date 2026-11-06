{
  description = "khakcsar - NixOS on Oracle Cloud A1";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, ...}: {
    # The base system as a reusable module, so other flakes can import it
    nixosModules.khakcsar = {
      imports = [
        disko.nixosModules.disko
        ./hosts/khakcsar
      ];
    };

    # A complete system built from just the base (for reference and installing)
    nixosConfigurations.khakcsar = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        self.nixosModules.khakcsar
      ];
    };
  };
}
