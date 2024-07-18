{ pkgs, ... }:
let
  git-branch-prune = pkgs.writeShellScriptBin "git-branch-prune" ''
    ${pkgs.git}/bin/git branch --merged | grep -v "\*" | xargs -n 1 ${pkgs.git}/bin/git branch --delete
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
      };
    };

    gh = {
      enable = true;
    };
  };

  home.packages = [ git-branch-prune ];
}
