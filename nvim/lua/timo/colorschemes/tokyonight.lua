-- See https://github.com/folke/tokyonight.nvim
return {
  "folke/tokyonight.nvim",
  lazy = false, -- make sure we load this during startup, because it's the main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  opts = {
    -- style = "day",
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    -- load the colorscheme
    -- vim.cmd([[colorscheme tokyonight]])
  end
}
