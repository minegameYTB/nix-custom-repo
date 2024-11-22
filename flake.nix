{
  description = "A basic custom repository";

 inputs = {
   nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
   flake-parts.url = "github:hercules-ci/flake-parts";
   systems.url = "github:nix-systems/default";
 };

 outputs = inputs@{ flake-parts, systems, ... }:
  flake-parts.lib.mkFlake { inherit inputs; } {
    systems = import systems;
    imports =[
    	./imports/packages-all.nix
    ];
  };
}
