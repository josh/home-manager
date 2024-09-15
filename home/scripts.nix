{ pkgs, ... }:
let
  patchShellScript = (import ./lib.nix).patchShellScript pkgs;

  codespace-fix-tmp-permissions = patchShellScript ./bin/codespace-fix-tmp-permissions.sh [
    pkgs.acl
  ];
  deadsymlinks = patchShellScript ./bin/deadsymlinks.sh [ pkgs.findutils ];
  touch-cachedir-tag = patchShellScript ./bin/touch-cachedir-tag.sh [ ];
in
{
  home.packages = [
    codespace-fix-tmp-permissions
    deadsymlinks
    touch-cachedir-tag
  ];
}
