{
  lib,
  config,
  pkgs,
  ...
}:
{
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

    starship =
      let
        preset = name: (lib.importTOML "${pkgs.starship}/share/starship/presets/${name}.toml");
      in
      {
        enable = config.powerline-fonts;
        settings = lib.mkMerge [
          (lib.mkIf (!config.nerd-fonts) (preset "no-nerd-font"))
          (lib.mkIf config.catppuccin.enable (
            # https://github.com/catppuccin/starship/blob/ca2fb06/starship.toml
            {
              directory.style = "bold lavender";
              palette = "catppuccin_${config.catppuccin.flavor}";
            }
            // (lib.importTOML "${config.catppuccin.sources.starship}/palettes/${config.catppuccin.flavor}.toml")
          ))
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
