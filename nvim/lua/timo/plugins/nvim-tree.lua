-- See https://github.com/nvim-tree/nvim-tree.lua/wiki/Installation
return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        diagnostics = { enable = true},
        git = { enable = true },
        filters = {
          custom = { "^.git$" },
        },
      })
    end,
    keys = {
      { "<leader>N", ":NvimTreeToggle<CR>", desc = "Toggle File Explorer" },
    }
  }
}
