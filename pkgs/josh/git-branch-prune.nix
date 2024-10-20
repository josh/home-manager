{
  patchShellScript,
  git,
}:
patchShellScript {
  scriptPath = ./git-branch-prune.sh;
  runtimeInputs = [ git ];
  preservePATH = true;
}
