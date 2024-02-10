-- See https://github.com/ruifm/gitlinker.nvim
return {
  {
    "ruifm/gitlinker.nvim",
    -- event = { "VeryLazy" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>gy",
        function() require("gitlinker").get_buf_range_url("n", {action_callback = require("gitlinker.actions").copy_to_clipboard}) end,
        desc = "Copy Git Link to Clipboard",
        mode = "n",
        silent = true,
      },
      {
        "<leader>gy",
        function() require("gitlinker").get_buf_range_url("v", {action_callback = require("gitlinker.actions").copy_to_clipboard}) end,
        desc = "Copy Git Link to Clipboard",
        mode = "v",
        silent = true,
      },
      {
        "<leader>gb",
        function() require("gitlinker").get_buf_range_url("n", {action_callback = require("gitlinker.actions").open_in_browser}) end,
        desc = "Open Git Link in Browser",
        mode = "n",
        silent = true,
      },
      {
        "<leader>gb",
        function() require("gitlinker").get_buf_range_url("v", {action_callback = require("gitlinker.actions").open_in_browser}) end,
        desc = "Open Git Link in Browser",
        mode = "v",
        silent = true,
      },
    },
    opts = {
      mappings = nil,
    },
  }
}
