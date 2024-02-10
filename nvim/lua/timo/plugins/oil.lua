-- See https://github.com/stevearc/oil.nvim
return {
  {
    'stevearc/oil.nvim',
    opts = {
      view_options = {
        is_hidden_file = function(name, bufnr)
          return name ~= ".." and vim.startswith(name, ".")
        end,
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>Fo", ":Oil<cr>", desc = "Open Files with Oil" },
      { "<leader>FF", ":Oil --float<cr>", desc = "Open Files with Oil" },
      { "<leader>FG", function() require("oil").open_float(require("lspconfig").util.find_git_ancestor(vim.fn.expand("%"))) end, desc = "Open Git Root with Oil" },
    }
  }
}
