{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
      package = pkgs.nixbits.git;
      includes = [ { path = pkgs.nixbits.git-config; } ];
    };
  };

  home.shellAliases = {
    "g" = "git";
  };
}
