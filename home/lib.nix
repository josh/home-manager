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

  patchShellScript =
    pkgs: scriptPath: runtimeInputs:
    let
      name = pkgs.lib.strings.removeSuffix ".sh" (builtins.baseNameOf scriptPath);
    in
    derivation {
      inherit (pkgs) system;
      inherit name;
      allowSubstitutes = true;
      preferLocalBuild = false;
      PATH = pkgs.lib.makeBinPath [ pkgs.coreutils ];
      builder = ./bin/build-shell-script.sh;
      RUNTIME_SHELL = "${pkgs.bash}/bin/bash";
      RUNTIME_PATH = pkgs.lib.makeBinPath runtimeInputs;
      SCRIPT_PATH = scriptPath;
    }
    // {
      meta = {
        mainProgram = name;
      };
    };
in
{
  inherit
    flake
    flakeInputs
    patchShellScript
    wrapImportInputs
    wrapImportsInputs
    ;
}
