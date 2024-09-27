pkgs:
let
  lib = import ../home/lib.nix;
  patchShellScript = lib.patchShellScript pkgs;
in
{
  codespace-fix-tmp-permissions = patchShellScript ../home/bin/codespace-fix-tmp-permissions.sh [
    pkgs.acl
  ];
  deadsymlinks = patchShellScript ../home/bin/deadsymlinks.sh [ pkgs.findutils ];
  touch-cachedir-tag = patchShellScript ../home/bin/touch-cachedir-tag.sh [ ];
}
