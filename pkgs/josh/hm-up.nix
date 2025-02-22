{
  patchShellScript,
  coreutils,
  git,
  nh,
  nix,
}:
patchShellScript {
  scriptPath = ./hm-up.sh;
  runtimeInputs = [
    coreutils
    git
    nh
    nix
  ];
}
