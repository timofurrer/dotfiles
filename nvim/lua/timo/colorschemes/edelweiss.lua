-- See https://github.com/timofurrer/edelweiss
return {
  -- "timofurrer/edelweiss",
  dir = "/Users/timo/work/edelweiss",
  lazy = false, -- make sure we load this during startup, because it's the main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  opts = {
  },
  config = function(plugin)
    vim.opt.rtp:append(plugin.dir .. "/nvim")
    -- load the colorscheme
    vim.cmd([[colorscheme edelweiss]])
  end
}
