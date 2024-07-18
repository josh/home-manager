_:
let
  shellAliases = {
    "g" = "git";
  };
in
{
  programs = {
    bash = {
      enable = true;
      inherit shellAliases;
    };

    zsh = {
      enable = true;
      inherit shellAliases;
    };

    starship = {
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
