final: prev:
let
  inherit (final) lib;
  prev' = lib.attrsets.mapAttrs' (name: lib.attrsets.nameValuePair "${name}'") prev;
  legacyPkgs = import ./pkgs/default.nix final;
  callPackage = lib.callPackageWith (final // prev' // legacyPkgs);
in
{
  josh =
    lib.filesystem.packagesFromDirectoryRecursive {
      inherit callPackage;
      directory = ./pkgs;
    }
    # TODO: Remove this workaround for scripts
    // legacyPkgs;
}
