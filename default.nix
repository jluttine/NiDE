{ pkgs ? import <nixpkgs> { } }:

pkgs.symlinkJoin {
  name = "nide";
  paths = (import ./nix/packages.nix) { inherit pkgs; };
}
