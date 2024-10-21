{
  useNerdFonts ? false,
  lib,
  formats,
}:
let
  yaml = formats.yaml { };
in
yaml.generate "lazygit-config.yml" (
  lib.attrsets.optionalAttrs useNerdFonts {
    gui.nerdFontsVersion = "3";
  }
)
