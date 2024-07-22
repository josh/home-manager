{ pkgs, ... }:
let
  git-branch-prune = pkgs.writeShellScriptBin "git-branch-prune" ''
    ${pkgs.git}/bin/git branch --merged | grep -v "\*" | xargs -n 1 ${pkgs.git}/bin/git branch --delete
  '';
  git-track = pkgs.writeShellScriptBin "git-track" ''
    branch=$(${pkgs.git}/bin/git branch 2>/dev/null | grep '^\*')
    [ "x$1" != x ] && tracking=$1 || tracking=''${branch/* /}

    ${pkgs.git}/bin/git config "branch.$tracking.remote" origin
    ${pkgs.git}/bin/git config "branch.$tracking.merge" "refs/heads/$tracking"

    echo "tracking origin/$tracking"
  '';
in
{
  programs = {
    git = {
      enable = true;
      userEmail = "josh@users.noreply.github.com";
      userName = "Joshua Peek";
      aliases = {
        b = "branch";
        ci = "commit";
        co = "checkout";
      };

      diff-so-fancy.enable = true;
      # other diff tools,
      # delta.enable = true;
      # difftastic.enable = true;
    };

    gh.enable = true;

    gitui = {
      enable = true;
      # Enable vim style key bindings.
      keyConfig = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/extrawurst/gitui/0cb5b781a20eb742132bbcad923bcec1a744d8ec/vim_style_key_config.ron";
        sha256 = "0mjz8c20qg0s4d5kv8y7wg0c9w42mjqj6fsgvib3g5cf404zv0mr";
      };
    };
  };

  home.packages = [
    git-branch-prune
    git-track
  ];
}
