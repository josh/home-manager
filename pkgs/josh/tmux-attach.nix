{
  patchShellScript,
  coreutils,
  tmux,
}:
patchShellScript {
  scriptPath = ./tmux-attach.sh;
  runtimeInputs = [
    coreutils
    tmux
  ];
  preservePATH = true;
}
