{
  patchShellScript,
  coreutils,
  gh,
  git,
  nh,
  nix,
}:
patchShellScript {
  scriptPath = ./os-up.sh;
  runtimeInputs = [
    coreutils
    gh
    git
    nh
    nix
  ];
}
