-- See https://github.com/nvim-telescope/telescope.nvim
local file_ignore_patterns = {
  "^.git/",
  "^node_modules/",
  "^.rubocop.*/",
}

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { "VeryLazy" },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files({ hidden = true, file_ignore_patterns = file_ignore_patterns }) end, desc = "Find Files" },
      { "<leader>fg", function() require("telescope.builtin").git_files() end, desc = "Find Git Files" },
      { "<leader>fG", function() require("telescope.builtin").live_grep() end, desc = "Live Grep" },
      { "<leader>f/", function() require("telescope.builtin").live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, desc = "Grep in Open Files" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
      { "<leader>ft", function() require("telescope.builtin").treesitter() end, desc = "Treesitter" },
      { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Find in diagnostics" },
      { "<leader>fs", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Fuzzy find in current buffer" },
    },
  },
  -- Extensions
  {
    "sopa0/telescope-makefile",
    dependencies = {
      "akinsho/nvim-toggleterm.lua",
    },
    config = function()
      require("telescope").load_extension("make")
    end,
    keys = {
      { "<leader>M", "<cmd>Telescope make<cr>", desc = "Call a Makefile Target", silent = true },
    },
  },
}
