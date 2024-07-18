{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      { plugin = copilot-vim; }
      {
        plugin = catppuccin-nvim;
        config = "colorscheme catppuccin";
      }
      {
        plugin = nvim-tree-lua;
        config = ''
          let g:loaded_netrw = 1
          let g:loaded_netrwPlugin = 1
          set termguicolors
        '';
      }
      {
        plugin = vim-startify;
        config = "let g:startify_change_to_vcs_root = 0";
      }
    ];

    extraConfig = '''';
    extraLuaConfig = ''
      require("nvim-tree").setup()
    '';
  };
}
