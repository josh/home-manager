pkgs:
let
  inherit (pkgs) lib;
  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];
  patchShellScript =
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
    };
in
rec {
  codespace-fix-tmp-permissions = patchShellScript {
    scriptPath = ./bin/codespace-fix-tmp-permissions.sh;
    runtimeInputs = with pkgs; [ acl ];
    platforms = [ "x86_64-linux" ];
  };

  deadsymlinks = patchShellScript {
    scriptPath = ./bin/deadsymlinks.sh;
    runtimeInputs = with pkgs; [ findutils ];
  };
  touch-cachedir-tag = patchShellScript {
    scriptPath = ./bin/touch-cachedir-tag.sh;
  };

  cachix-push = patchShellScript {
    scriptPath = ./bin/cachix-push.sh;
    runtimeInputs = with pkgs; [ cachix ];
  };
  os-up = patchShellScript {
    scriptPath = ./bin/os-up.sh;
    runtimeInputs = with pkgs; [
      cachix-push
      coreutils
      gh
      git
      nh
      nix
    ];
  };
  hm-up = patchShellScript {
    scriptPath = ./bin/hm-up.sh;
    runtimeInputs = with pkgs; [
      cachix-push
      coreutils
      git
      nh
      nix
    ];
  };

  git-branch-prune = patchShellScript {
    scriptPath = ./bin/git-branch-prune.sh;
    runtimeInputs = with pkgs; [ git ];
    preservePATH = true;
  };
  git-track = patchShellScript {
    scriptPath = ./bin/git-track.sh;
    runtimeInputs = with pkgs; [ git ];
    preservePATH = true;
  };

  tmux-attach = patchShellScript {
    scriptPath = ./bin/tmux-attach.sh;
    runtimeInputs = with pkgs; [
      coreutils
      tmux
    ];
    preservePATH = true;
  };

  test-fonts = patchShellScript {
    scriptPath = ./bin/test-fonts.sh;
  };
}
