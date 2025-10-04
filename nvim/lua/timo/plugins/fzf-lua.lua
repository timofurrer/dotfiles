-- see https://github.com/ibhagwan/fzf-lua
return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      fzf_colors = true, -- auto-generate fzf colorscheme from current Neovim colorscheme
      files = {
        actions = {
          ["default"] = require("fzf-lua.actions").file_edit,
        },
      },
      oldfiles = {
        include_current_session = true,
      },
      grep = {
        rg_glob = true,
      },
    },
    keys = {
      { "<leader><leader>", function() require("fzf-lua").files() end,                 desc = "Find Files" },
      { "<leader>fo",       function() require("fzf-lua").oldfiles() end,              desc = "Find in opened files history" },
      { "<leader>ff",       function() require("fzf-lua").files() end,                 desc = "Find Files" },
      { "<leader>fg",       function() require("fzf-lua").git_files() end,             desc = "Find Git Files" },
      { "<leader>fG",       function() require("fzf-lua").live_grep_native() end,      desc = "Live Grep (faster in large code bases)" },
      { "<leader>fR",       function() require("fzf-lua").grep() end,                  desc = "Rip Grep (not live)" },
      { "<leader>f/",       function() require("fzf-lua").lgrep_curbuf() end,          desc = "Grep in Open Files" },
      { "<leader>fb",       function() require("fzf-lua").buffers() end,               desc = "Buffers" },
      { "<leader>ft",       function() require("fzf-lua").treesitter() end,            desc = "Treesitter" },
      { "<leader>fd",       function() require("fzf-lua").diagnostics_workspace() end, desc = "Find in diagnostics" },
      { "<leader>fh",       function() require("fzf-lua").search_history() end,        desc = "Find in search history" },
    },
  }
}
