{ pkgs, config, ... }:
{
  programs = {
    git = {
      enable = true;
      includes = [
        { path = pkgs.josh.git-config; }
      ];

      # diff-so-fancy.enable = true;
      # other diff tools,
      # delta.enable = true;
      # difftastic.enable = true;
    };

    gh.enable = true;

    gitui = {
      enable = true;
      # Enable vim style key bindings.
      keyConfig = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/extrawurst/gitui/0cb5b781a20eb742132bbcad923bcec1a744d8ec/vim_style_key_config.ron";
        sha256 = "0mjz8c20qg0s4d5kv8y7wg0c9w42mjqj6fsgvib3g5cf404zv0mr";
      };
    };

    lazygit = {
      enable = true;
      settings = {
        gui = {
          nerdFontsVersion = if config.my.nerd-fonts then "3" else "";
        };
      };
    };
  };

  home.shellAliases = {
    "g" = "git";
  };
}
