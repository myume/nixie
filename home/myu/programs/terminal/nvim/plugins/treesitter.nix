{pkgs, ...}: {
  programs.nvf.settings.vim = {
    treesitter = {
      enable = true;
      fold = true;
      autotagHtml = true;
      grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
        htmldjango
      ];
      indent = {
        enable = true;
        excludes = ["qml"];
      };
    };
  };
}
