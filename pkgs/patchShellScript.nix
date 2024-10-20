pkgs:
let
  inherit (pkgs) lib;
  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];
in
{
  scriptPath,
  runtimeInputs ? [ ],
  preservePATH ? false,
  platforms ? systems,
}:
let
  name = lib.strings.removeSuffix ".sh" (builtins.baseNameOf scriptPath);
  runtimePath = lib.makeBinPath runtimeInputs;
  runtimePathSuffix = if preservePATH then ":$PATH" else "";
in
pkgs.stdenvNoCC.mkDerivation {
  inherit name;

  src = scriptPath;
  dontUnpack = true;

  installPhase = ''
    mkdir -p "$out/bin"

    cat <<EOF >"$out/bin/$name"
    #!${pkgs.bash}/bin/bash
    export PATH="${runtimePath}${runtimePathSuffix}"
    $(sed '1d' "''${src}")
    EOF
    chmod +x "$out/bin/$name"    
  '';

  meta.mainProgram = name;
  meta.platforms = platforms;
}
