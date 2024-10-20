{ formats }:
let
  toml = formats.toml { };
in
toml.generate "jj-config.toml" {
  user = {
    name = "Joshua Peek";
    email = "josh@users.noreply.github.com";
  };
}
