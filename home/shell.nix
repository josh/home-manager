{
  lib,
  config,
  pkgs,
  ...
}:
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

    starship =
      let
        preset = name: (lib.importTOML "${pkgs.starship}/share/starship/presets/${name}.toml");
      in
      {
        enable = true;
        settings = lib.mkMerge [
          # (lib.mkIf (!config.nerd-fonts) (preset "no-nerd-font"))
          # (lib.mkIf config.nerd-fonts (preset "nerd-font-symbols"))
          (lib.mkIf (config.theme == "tokyonight") (preset "tokyo-night"))
          (lib.mkIf (config.theme == "catppuccin") (
            {
              format = "$all";
              character = {
                error_symbol = "[❯](red)";
                success_symbol = "[[♥](green) ❯](maroon)";
                vimcmd_symbol = "[❮](green)";
              };
              directory = {
                style = "bold lavender";
                truncation_length = 4;
              };
              palette = "catppuccin_mocha";
            }
            // (lib.importTOML "${config.catppuccin.sources.starship}/palettes/mocha.toml")
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
