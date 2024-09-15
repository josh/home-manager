{ pkgs, ... }:
let
  patchShellScript = (import ./lib.nix).patchShellScript pkgs;

  # https://github.com/NixOS/nix/issues/6680
  codespace-fix-tmp-permissions = pkgs.writeShellScriptBin "codespace-fix-tmp-permissions" ''
    OLD_ACL=$(${pkgs.acl}/bin/getfacl /tmp)
    sudo ${pkgs.acl}/bin/setfacl -k /tmp
    NEW_ACL=$(${pkgs.acl}/bin/getfacl /tmp)

    if [ "$OLD_ACL" != "$NEW_ACL" ]; then
      echo "ACLs changed:"
      echo "$OLD_ACL"
      echo "---"
      echo "$NEW_ACL"
    else
        echo "ACLs are the same"
    fi
  '';

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
