-- See https://github.com/stevearc/conform.nvim
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f-",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black", "ruff_fix", "ruff_format" },
      go = { "gofmt", "goimports" },
      jsonnet = { "jsonnetfmt" },
      markdown = { "markdownlint-cli2" },
      ruby = { "rubocop" },
      sh = { "shellcheck", "shellharden", "shfmt" },
      terraform = { "terraform_fmt" },
      yaml = { "yamlfmt" },
    },

    -- Set up format-on-save
    -- format_on_save = { timeout_ms = 500, lsp_fallback = true },
    -- Customize formatters
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2" },
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
