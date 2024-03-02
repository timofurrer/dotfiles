local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node

ls.add_snippets("all", {
  s("email", t "tuxtimo@gmail.com"),
  s({ trig = "date" }, {
    f(function()
      return string.format(string.gsub(vim.bo.commentstring, "%%s", " %%s"), os.date())
    end, {}),
  }),
})
