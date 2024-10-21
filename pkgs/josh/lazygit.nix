{
  useNerdFonts ? false,
  symlinkJoin,
  makeWrapper,
  lazygit,
  josh,
  testers,
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

  passthru.tests = {
    version = testers.testVersion {
      package = josh.lazygit;
      command = "lazygit --version";
      inherit (lazygit) version;
    };
  };
}
