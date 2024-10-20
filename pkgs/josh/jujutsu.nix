{
  symlinkJoin,
  makeWrapper,
  jujutsu,
  josh,
}:
symlinkJoin {
  name = "josh-jujutsu";
  paths = [ jujutsu ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/jj \
      --set JJ_CONFIG ${josh.jujutsu-config}
  '';

  # TODO: Add tests
  # - Assert `jj config get user.name`
}
