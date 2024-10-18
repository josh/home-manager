final: prev:
let
  inherit (final) lib;
  lib' = import ./pkgs/lib.nix final;
  prev' = lib.attrsets.mapAttrs' (name: lib.attrsets.nameValuePair "${name}'") prev;
  callPackage = lib.callPackageWith (final // prev' // lib');
in
{
  josh = lib.filesystem.packagesFromDirectoryRecursive {
    inherit callPackage;
    directory = ./pkgs;
  };
}
