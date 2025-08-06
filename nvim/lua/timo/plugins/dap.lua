-- XDG cache directory helper functions
local function get_xdg_cache_dir()
  local xdg_cache = os.getenv("XDG_CACHE_HOME")
  if xdg_cache and xdg_cache ~= "" then
    return xdg_cache
  else
    return vim.fn.expand("~/.cache")
  end
end

local function get_workspace_hash()
  local workspace = vim.fn.getcwd()
  -- Create a simple hash of the workspace path
  local hash = 0
  for i = 1, #workspace do
    hash = (hash * 31 + string.byte(workspace, i)) % 2147483647
  end
  return tostring(hash)
end

local function get_cache_file_path(cache_type)
  local cache_dir = get_xdg_cache_dir() .. "/nvim/dap-go"
  local workspace_hash = get_workspace_hash()
  vim.fn.mkdir(cache_dir, "p")
  return cache_dir .. "/" .. workspace_hash .. "_" .. cache_type .. ".txt"
end

local function read_cache(cache_type, default_value)
  local cache_file = get_cache_file_path(cache_type)
  local file = io.open(cache_file, "r")
  if file then
    local content = file:read("*all")
    file:close()
    return content:gsub("%s+$", "") -- trim trailing whitespace
  end
  return default_value or ""
end

local function write_cache(cache_type, value)
  if not value or value == "" then
    return
  end
  local cache_file = get_cache_file_path(cache_type)
  local file = io.open(cache_file, "w")
  if file then
    file:write(value)
    file:close()
  end
end

local dap_go_command_config = {
  type = "go",
  name = "Debug Command (Arguments)",
  request = "launch",
  outputMode = "remote",
  program = function()
    return coroutine.create(function(dap_run_co)
      local cached_path = read_cache("command_path", vim.fn.getcwd())
      vim.ui.input({
        prompt = 'Command Path: ',
        default = cached_path,
        completion = "file"
      }, function(input)
        if input and input ~= "" then
          write_cache("command_path", input)
        end
        coroutine.resume(dap_run_co, input)
      end)
    end)
  end,
  args = function()
    return coroutine.create(function(dap_run_co)
      local cached_args = read_cache("arguments", "")
      vim.ui.input({
        prompt = "Args: ",
        default = cached_args,
      }, function(input)
        if input and input ~= "" then
          write_cache("arguments", input)
        end
        local args = vim.split(input or "", " ")
        coroutine.resume(dap_run_co, args)
      end)
    end)
  end
}

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
        -- dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        -- dapui.close()
      end
    end,
    keys = {
      { "<leader>d",   desc = "DAP" },
      -- Use common IDE mappings
      { "<F5>",        function() require("dap").continue() end,                                                    desc = "Continue Execution" },
      { "<F7>",        function() require("dap").step_into() end,                                                   desc = "Step Into" },
      { "<F8>",        function() require("dap").step_over() end,                                                   desc = "Step Over" },
      { "<F9>",        function() require("dap").toggle_breakpoint() end,                                           desc = "Toggle Breakpoint" },
      -- Use my mappings
      { "<leader>dc",  function() require("dap").continue() end,                                                    desc = "Continue Execution (<F5>)" },
      { "<leader>di",  function() require("dap").step_into() end,                                                   desc = "Step Into (<F7>)" },
      { "<leader>do",  function() require("dap").step_over() end,                                                   desc = "Step Over (<F8>)" },
      { "<leader>db",  function() require("dap").toggle_breakpoint() end,                                           desc = "Toggle Breakpoint (<F9>)" },
      { "<leader>dB",  function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,        desc = "Set conditional breakpoint" },
      { "<leader>dlp", function() require("dap").set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, desc = "Set breakpoing with log point message" },
    },
  },
  -- UI enhancements
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = { "go", "ruby" },
    opts = {},
    keys = {
      { "<leader>du", function() require("dapui").toggle() end,    desc = "Toggle DAP UI" },
      { "<leader>de", function() require("dapui").eval() end,      desc = "Eval expression in selection", mode = "v" },
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
      { "<leader>dtv", function() require("telescope").extensions.dap.variables() end,        desc = "List all variables" },
      { "<leader>dtf", function() require("telescope").extensions.dap.frames() end,           desc = "List all frames" },
    }
  },
  -- Adapters
  {
    -- NOTE: requires delve: go install github.com/go-delve/delve/cmd/dlv@latest
    "leoluz/nvim-dap-go",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "go",
    opts = {},
    config = function()
      local dap_go = require('dap-go')
      local dap = require('dap')

      dap_go.setup({
        dap_configurations = {
          {
            type = "go",
            name = "Debug Package (Arguments)",
            request = "launch",
            program = "${fileDirname}",
            args = dap_go.get_arguments,
            outputMode = "remote",
          },
          dap_go_command_config,
        },
      })
    end,
    keys = {
      { "<leader>da",  function() require("dap").run(dap_go_command_config) end, desc = "Debug command" },
      { "<leader>dla", function() require("dap").run_last() end,                 desc = "Debug last configuration" },
    }
  },
  {
    -- NOTE: requires debug.rb: gem install debug
    "suketa/nvim-dap-ruby",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "ruby",
    opts = {},
  }
}
