{
  patchShellScript,
  runCommand,
  git,
  josh,
}:
patchShellScript {
  scriptPath = ./git-track.sh;
  runtimeInputs = [ git ];
  preservePATH = true;
}
// {
  passthru.tests = {
    test =
      runCommand "test-git-track"
        {
          nativeBuildInputs = [
            git
            josh.git-track
          ];
        }
        ''
          git init
          git track
          touch $out
        '';
  };
}
