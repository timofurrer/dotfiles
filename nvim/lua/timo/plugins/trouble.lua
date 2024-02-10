-- See https://github.com/folke/trouble.nvim
return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      { "<leader>xx", function() require("trouble").toggle() end, desc = "Toggle trouble" },
      { "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end, desc = "Toggle Workspace Diagnostics" },
      { "<leader>xd", function() require("trouble").toggle("document_diagnostics") end, desc = "Toggle Document Diagnostics" },
      { "<leader>xq", function() require("trouble").toggle("quickfix") end, desc = "Toggle Quickfix" },
      { "<leader>xl", function() require("trouble").toggle("loclist") end, desc = "Toggle Loclist" },
    },
  }
}
