{
  symlinkJoin,
  makeWrapper,
  runCommand,
  bat,
  gh,
  josh,
  testers,
}:
symlinkJoin {
  name = "josh-gh";
  paths = [
    gh
    josh.git
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/gh \
      --set GH_CONFIG_DIR ${josh.gh-config}
  '';

  meta.mainProgram = "gh";

  passthru.tests = {
    version = testers.testVersion {
      package = josh.gh;
      command = "gh version";
      inherit (gh) version;
    };

    config =
      runCommand "test-gh-config"
        {
          nativeBuildInputs = [ josh.gh ];
        }
        ''
          expected="https"
          actual="$(gh config get git_protocol)"
          if [[ "$actual" != "$expected" ]]; then
            echo "expected, '$expected' but was '$actual'"
            return 1
          fi

          expected="${bat}/bin/bat"
          actual="$(gh config get pager)"
          if [[ "$actual" != "$expected" ]]; then
            echo "expected, '$expected' but was '$actual'"
            return 1
          fi
          touch $out
        '';
  };
}
