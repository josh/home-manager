{
  patchShellScript,
  josh,
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
    josh.cachix-push
    nh
    nix
  ];
}
