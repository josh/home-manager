{
  patchShellScript,
  bash,
  coreutils,
  findutils,
  git,
}:
patchShellScript {
  scriptPath = ./git-fetch-dir.sh;
  runtimeInputs = [
    bash
    coreutils
    findutils
    git
  ];
}
