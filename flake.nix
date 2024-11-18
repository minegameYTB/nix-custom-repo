{
  description = "A basic custom repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.${system} = rec {
      sshrm = pkgs.callPackage ./pkgs/sshrm {};
      ### Add new pkgs here
    };
  };
}
