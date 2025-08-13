-- See https://github.com/nvim-telescope/telescope.nvim
local file_ignore_patterns = {
  "^.git/",
  "^node_modules/",
  "^.rubocop.*/",
}

---Telescope action helper to open single or multiple files
---@param bufnr integer Telescope prompt buffer number
local function telescope_open_single_or_multi(bufnr)
  local actions = require("telescope.actions")
  local actions_state = require("telescope.actions.state")
  local multi_selection = actions_state.get_current_picker(bufnr):get_multi_selection()

  if not vim.tbl_isempty(multi_selection) then
    -- Multiple files selected: close telescope and open each one
    actions.close(bufnr)
    for _, file in pairs(multi_selection) do
      if file.path ~= nil or file.filename ~= nil then
        local filepath = file.path or file.filename
        vim.cmd(string.format("edit %s", vim.fn.fnameescape(filepath)))
      end
    end
  else
    -- Single file selection: use default telescope action for proper line positioning
    actions.select_default(bufnr)
  end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { "VeryLazy" },
    opts = {
      defaults = {
        mappings = {
          ["i"] = {
            ["<CR>"] = telescope_open_single_or_multi,
          },
        },
      },
    },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({
            hidden = true,
            file_ignore_patterns =
                file_ignore_patterns
          })
        end,
        desc = "Find Files"
      },
      { "<leader>fg", function() require("telescope.builtin").git_files() end, desc = "Find Git Files" },
      { "<leader>fG", function() require("telescope.builtin").live_grep() end, desc = "Live Grep" },
      {
        "<leader>f/",
        function()
          require("telescope.builtin").live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        desc = "Grep in Open Files"
      },
      { "<leader>fb", function() require("telescope.builtin").buffers() end,                   desc = "Buffers" },
      { "<leader>ft", function() require("telescope.builtin").treesitter() end,                desc = "Treesitter" },
      { "<leader>fd", function() require("telescope.builtin").diagnostics() end,               desc = "Find in diagnostics" },
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
