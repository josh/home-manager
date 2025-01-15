{
  symlinkJoin,
  makeWrapper,
  runCommand,
  git,
  nixbits,
  josh,
  testers,
}:
symlinkJoin {
  name = "josh-git";
  paths = [
    git
    nixbits.git-branch-prune
    nixbits.git-fetch-dir
    nixbits.git-track
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/git \
      --set GIT_CONFIG_GLOBAL ${josh.git-config}
  '';

  meta.mainProgram = "git";

  passthru.tests = {
    version = testers.testVersion {
      package = josh.git;
      command = "git version";
      inherit (git) version;
    };

    config =
      runCommand "test-git-config"
        {
          nativeBuildInputs = [ josh.git ];
        }
        ''
          expected="Joshua Peek"
          actual="$(git config get user.name)"
          if [[ "$actual" != "$expected" ]]; then
            echo "expected, '$expected' but was '$actual'"
            return 1
          fi
          touch $out
        '';

    init =
      runCommand "test-default-branch"
        {
          nativeBuildInputs = [ josh.git ];
        }
        ''
          git init
          if [[ "$(git branch --show-current)" != "main" ]]; then
            echo "expected, 'main' but was '$(git branch --show-current)'"
            return 1
          fi
          touch $out
        '';

    track =
      runCommand "test-git-config"
        {
          nativeBuildInputs = [ josh.git ];
        }
        ''
          git init
          git commit --allow-empty -m "initial commit"
          git track
          touch $out
        '';
  };
}
