{
  patchShellScript,
  findutils,
  josh,
  writeText,
  runCommand,
  testers,
}:
patchShellScript {
  scriptPath = ./deadsymlinks.sh;
  runtimeInputs = [ findutils ];
}
// {
  passthru.tests = {
    test = testers.testEqualContents {
      assertion = "deadsymlinks works";
      expected = writeText "expected" ''
        ./bar-symlink
      '';
      actual =
        runCommand "actual"
          {
            nativeBuildInputs = [ josh.deadsymlinks ];
          }
          ''
            echo 42 >foo
            echo 42 >bar
            ln -s foo foo-symlink
            ln -s bar bar-symlink
            rm bar

            deadsymlinks >$out
          '';
    };
  };
}
