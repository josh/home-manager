{
  symlinkJoin,
  makeWrapper,
  lazygit,
  josh,
  useNerdFonts ? false,
}:
symlinkJoin {
  name = "josh-lazygit";
  paths = [
    lazygit
    josh.git
  ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/lazygit \
      --set LG_CONFIG_FILE ${josh.lazygit-config.override { inherit useNerdFonts; }}
  '';

  meta.mainProgram = "lazygit";
}
