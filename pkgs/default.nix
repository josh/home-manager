pkgs:
let
  inherit (pkgs) lib;
  patchShellScript =
    scriptPath: runtimeInputs:
    let
      name = lib.strings.removeSuffix ".sh" (builtins.baseNameOf scriptPath);
    in
    derivation {
      inherit (pkgs) system;
      inherit name;
      PATH = lib.makeBinPath [ pkgs.coreutils ];
      builder = ./bin/build-shell-script.sh;
      RUNTIME_SHELL = "${pkgs.bash}/bin/bash";
      RUNTIME_PATH = lib.makeBinPath runtimeInputs;
      SCRIPT_PATH = scriptPath;
    }
    // {
      meta = {
        mainProgram = name;
      };
    };
in
rec {
  codespace-fix-tmp-permissions = patchShellScript ./bin/codespace-fix-tmp-permissions.sh [
    pkgs.acl
  ];
  deadsymlinks = patchShellScript ./bin/deadsymlinks.sh [ pkgs.findutils ];
  touch-cachedir-tag = patchShellScript ./bin/touch-cachedir-tag.sh [ ];

  cachix-push = patchShellScript ./bin/cachix-push.sh [ pkgs.cachix ];
  os-up = patchShellScript ./bin/os-up.sh (
    with pkgs;
    [
      cachix-push
      coreutils
      gh
      git
      nh
      nix
    ]
  );
  hm-up = patchShellScript ./bin/hm-up.sh (
    with pkgs;
    [
      cachix-push
      coreutils
      git
      nh
      nix
    ]
  );
}
