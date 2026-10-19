{pkgs, ...}: {
  programs.nvf.settings.vim.extraPlugins = {
    no-neck-pain-nvim = {
      package = pkgs.vimPlugins.no-neck-pain-nvim;
      setup = ''
        require("no-neck-pain").setup({
          width = 120,
          mappings = {
            enabled = true,
          },
        })
      '';
    };
  };
}
