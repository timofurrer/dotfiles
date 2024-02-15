-- See https://github.com/f-person/git-blame.nvim
return {
  {
    'f-person/git-blame.nvim',
    opts = {},
    keys = {
      { "<leader>Gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle blame information" },
      { "<leader>GB", "<cmd>GitBlameOpenFileURL<cr>", desc = "Open blame in browser" },
    }
  }
}
