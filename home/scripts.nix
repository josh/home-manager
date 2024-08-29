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

  # http://www.brynosaurus.com/cachedir/
  touch-cachedir-tag = pkgs.writeShellScriptBin "touch-cachedir-tag" ''
    echo "Signature: 8a477f597d28d172789f06886806bc55" >CACHEDIR.TAG
  '';
in
{
  home.packages = [
    codespace-fix-tmp-permissions
    deadsymlinks
    touch-cachedir-tag
  ];
}
