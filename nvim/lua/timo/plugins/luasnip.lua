-- See https://github.com/L3MON4D3/LuaSnip
return {
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    config = function()
      local ls = require("luasnip")
      local types = require("luasnip.util.types")

      ls.setup({
        updateevents = "TextChanged,TextChangedI",

        enable_autosnippets = true,

        ext_ops = {
          [types.choiceNode] = {
            active = {
              virt_text = { { " « ", "NonTest" } },
            },
          },
        },
      })

      for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/timo/snips/ft/*.lua", true)) do
        loadfile(ft_path)()
      end
    end,
  }
}
