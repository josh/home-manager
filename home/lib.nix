let
  flake =
    let
      lock = builtins.fromJSON (builtins.readFile ../flake.lock);
      node = lock.nodes.flake-compat.locked;
      inherit (node) owner repo rev;
      path = fetchTarball {
        url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
        sha256 = node.narHash;
      };
      flake = import path { src = ../.; };
    in
    flake.defaultNix;

  flakeInputs = flake.inputs;

  wrapImportInputs =
    inputs: path:
    (
      let
        mod = import path;
        isFunction = builtins.isFunction mod;
        wrappedMod =
          args@{
            pkgs,
            lib,
            config,
            options,
            ...
          }:
          mod (
            {
              inherit
                pkgs
                lib
                config
                options
                inputs
                ;
            }
            // args
          );
      in
      if isFunction then wrappedMod else mod
    );

  wrapImportsInputs = inputs: imports: builtins.map (wrapImportInputs inputs) imports;
in
{
  inherit
    flake
    flakeInputs
    wrapImportInputs
    wrapImportsInputs
    ;
}
