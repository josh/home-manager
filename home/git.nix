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
        ci = "commit";
        co = "checkout";
      };
    };

    gitui.enable = true;
    gh.enable = true;
  };

  home.packages = [
    git-branch-prune
    git-track
  ];
}
