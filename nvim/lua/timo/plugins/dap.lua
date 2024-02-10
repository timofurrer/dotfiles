-- See https://github.com/mfussenegger/nvim-dap
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      -- DAP UI enhancements
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
    },
    ft = { "go", "ruby" },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      -- Use nvim-dap events to automatically open and close the DAP UI.
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
    keys = {
      { "<leader>d", desc = "DAP" },
      -- Use common IDE mappings
      { "<F5>", function() require("dap").continue() end, desc = "Continue Execution" },
      { "<F7>", function() require("dap").step_into() end, desc = "Step Into" },
      { "<F8>", function() require("dap").step_over() end, desc = "Step Over" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      -- Use my mappings
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue Execution (<F5>)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into (<F7>)" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over (<F8>)" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint (<F9>)" },
    },
  },
  -- UI enhancements
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = { "go", "ruby" },
    opts = {},
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval expression in selection", mode = "v" },
      { "<leader>dr", function() require("dapui").repl.open() end, desc = "Open DAP REPL" },
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = { "go", "ruby" },
    opts = {},
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    ft = { "go", "ruby" },
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("dap")
    end,
    keys = {
      { "<leader>dtb", function() require("telescope").extensions.dap.list_breakpoints() end, desc = "List all breakpoints" },
      { "<leader>dtv", function() require("telescope").extensions.dap.variables() end, desc = "List all variables" },
      { "<leader>dtf", function() require("telescope").extensions.dap.frames() end, desc = "List all frames" },
    }
  },
  -- Adapters
  {
    -- NOTE: requires delve: go install github.com/go-delve/delve/cmd/dlv@latest
    "leoluz/nvim-dap-go",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "go",
    opts = {},
  },
  {
    -- NOTE: requires debug.rb: gem install debug
    "suketa/nvim-dap-ruby",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "ruby",
    opts = {},
  }
}
