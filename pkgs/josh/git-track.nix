{
  patchShellScript,
  git,
}:
patchShellScript {
  scriptPath = ./git-track.sh;
  runtimeInputs = [ git ];
  preservePATH = true;
}
