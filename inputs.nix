# Helper to allow NixOS modules to access flake inputs.
#
# Cut down version of <https://github.com/edolstra/flake-compat> that only
# resolves inputs skippping the root outputs.

let
  lockFile = builtins.fromJSON (builtins.readFile ./flake.lock);

  fetchTree =
    info:
    assert info.type == "github";
    {
      outPath = fetchTarball ({
        url = "https://github.com/${info.owner}/${info.repo}/archive/${info.rev}.tar.gz";
        sha256 = info.narHash;
      });
      rev = info.rev;
      shortRev = builtins.substring 0 7 info.rev;
      lastModified = info.lastModified;
      narHash = info.narHash;
    };

  resolveInput =
    inputSpec: if builtins.isList inputSpec then getInputByPath "root" inputSpec else inputSpec;
  getInputByPath =
    nodeName: path:
    if path == [ ] then
      nodeName
    else
      getInputByPath (resolveInput lockFile.nodes.${nodeName}.inputs.${builtins.head path}) (
        builtins.tail path
      );

  buildNode =
    key: node:
    assert key != "root";
    let
      sourceInfo = fetchTree (node.info or { } // removeAttrs node.locked [ "dir" ]);
      subdir = node.locked.dir or "";
      outPath = sourceInfo + ((if subdir == "" then "" else "/") + subdir);
      flake = import (outPath + "/flake.nix");
      inputs = builtins.mapAttrs (inputName: inputSpec: nodes.${resolveInput inputSpec}) (
        node.inputs or { }
      );
      outputs = flake.outputs (inputs // { self = result; });
      result =
        outputs
        // sourceInfo
        // {
          inherit
            outPath
            inputs
            outputs
            sourceInfo
            ;
          _type = "flake";
        };

    in
    result;
  depNodes = builtins.removeAttrs lockFile.nodes [ "root" ];
  nodes = builtins.mapAttrs buildNode depNodes;
in
nodes
