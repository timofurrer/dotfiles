-- See https://github.com/f-person/git-blame.nvim
return {
  {
    'f-person/git-blame.nvim',
    opts = {
      enabled = false,
      message_template = "<<sha>> • <author> • <date> • <summary>",
      date_format = "%Y-%m-%d",
      highlight_group = "GitBlameVirtualLine",
    },
    keys = {
      { "<leader>Gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle blame information" },
      { "<leader>GB", "<cmd>GitBlameOpenFileURL<cr>", desc = "Open blame in browser" },
      { "<leader>Gs", "<cmd>GitBlameCopySHA<cr>", desc = "Copy blame SHA" },
    }
  }
}
