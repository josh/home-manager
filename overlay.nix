final: prev:
let
  inherit (final) lib;
  prev' = lib.attrsets.mapAttrs' (name: lib.attrsets.nameValuePair "${name}'") prev;
  callPackage = lib.callPackageWith (final // prev');
in
{
  josh =
    lib.filesystem.packagesFromDirectoryRecursive {
      inherit callPackage;
      directory = ./pkgs;
    }
    # TODO: Remove this workaround for scripts
    // (import ./pkgs/default.nix final);
}