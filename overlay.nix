final: prev:
let
  inherit (final) lib;
  private' = {
    patchShellScript = import ./pkgs/patchShellScript.nix final;
  };
  prev' = lib.attrsets.mapAttrs' (name: lib.attrsets.nameValuePair "${name}'") prev;
  callPackage = lib.callPackageWith (final // prev' // private');
in
{
  josh = lib.filesystem.packagesFromDirectoryRecursive {
    inherit callPackage;
    directory = ./pkgs/josh;
  };
}
