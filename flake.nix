{
  description = "System and user configurations.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      battlestation = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/battlestation/configuration.nix ];
      };
    };
  };
}
