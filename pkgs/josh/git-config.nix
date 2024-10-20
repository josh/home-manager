{
  lib,
  hostPlatform,
  formats,
  gh,
  less,
  diff-so-fancy,
}:
let
  gitIni = formats.gitIni { };
in
gitIni.generate "git-config.ini" {
  user = {
    name = "Joshua Peek";
    email = "josh@users.noreply.github.com";
  };
  github = {
    user = "josh";
  };

  alias = {
    b = "branch";
    ba = "branch --all";
    co = "checkout";
    ct = "checkout --track";
    ci = "commit --verbose";
    ca = "commit --all --verbose";
    st = "status --short --branch";
    up = "pull";
  };

  pull.rebase = false;
  fetch.prune = true;
  init.defaultBranch = "main";

  credential =
    {
      "https://github.com".helper = "${gh}/bin/gh auth git-credential";
      "https://gist.github.com".helper = "${gh}/bin/gh gist auth git-credential";
    }
    // (lib.attrsets.optionalAttrs hostPlatform.isMacOS {
      helper = "osxkeychain";
    });

  # diff-so-fancy
  core = {
    pager = "${diff-so-fancy}/bin/diff-so-fancy | ${less}/bin/less --tabs=4 -RF";
    interactive = {
      diffFilter = "${diff-so-fancy}/bin/diff-so-fancy --patch";
    };
  };
}
