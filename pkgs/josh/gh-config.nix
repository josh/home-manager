{
  formats,
  runCommand,
  bat,
}:
let
  yaml = formats.yaml { };
  configFile = yaml.generate "gh-config.yml" {
    version = 1;
    pager = "${bat}/bin/bat";
  };
in
runCommand "gh-config-dir" { } ''
  mkdir -p $out/
  cp ${configFile} $out/config.yml
''
