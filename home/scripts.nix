{ pkgs, ... }:
let
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

  deadsymlinks = pkgs.writeShellScriptBin "deadsymlinks" ''
    find . -type l ! -exec test -r {} \; -print 2>/dev/null
  '';
in
{
  home.packages = [
    codespace-fix-tmp-permissions
    deadsymlinks
  ];
}
