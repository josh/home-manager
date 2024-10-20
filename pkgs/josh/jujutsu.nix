{
  symlinkJoin,
  makeWrapper,
  runCommand,
  jujutsu,
  josh,
  testers,
}:
symlinkJoin {
  name = "josh-jujutsu";
  paths = [ jujutsu ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/jj \
      --set JJ_CONFIG ${josh.jujutsu-config}
  '';

  meta.mainProgram = "jj";

  passthru.tests = {
    version = testers.testVersion {
      package = josh.jujutsu;
      command = "jj version";
      inherit (jujutsu) version;
    };

    config =
      runCommand "test-jj-config"
        {
          nativeBuildInputs = [ josh.jujutsu ];
        }
        ''
          expected="Joshua Peek"
          actual="$(jj config get user.name)"
          if [[ "$actual" != "$expected" ]]; then
            echo "expected, '$expected' but was '$actual'"
            return 1
          fi
          touch $out
        '';
  };
}
