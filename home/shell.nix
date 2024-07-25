{ lib, config, ... }:
{
  home = {
    shellAliases = {
      "g" = "git";
    };
  };

  programs = {
    bash = {
      enable = true;
      historyControl = [ "ignorespace" ];
    };

    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      history = {
        extended = true;
        ignoreSpace = true;
        share = false;
      };
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };

    starship = {
      enable = true;
      settings = lib.mkMerge [
        (lib.mkIf (!config.nerd-fonts) (import ./starship/no-nerd-font.nix))
        # (lib.mkIf config.nerd-fonts (import ./starship/nerd-font-symbols.nix))
        (lib.mkIf (config.theme == "tokyonight") (import ./starship/tokyo-night.nix))
        (lib.mkIf (config.theme == "catppuccin") (import ./starship/catppuccin.nix))
      ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    less.enable = true;

    bat = {
      enable = true;
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
