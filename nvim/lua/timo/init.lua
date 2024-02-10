-- Bootstrapping Lazy.nvim, see https://github.com/folke/lazy.nvim?tab=readme-ov-file#-installation

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to configure leader key before Lazy, so that all mappings are correct
require("timo.leader")

-- Load plugins
require("lazy").setup({
  spec = {
    { import = "timo.colorschemes" },
    { import = "timo.plugins" },
  }
})

-- Load configuration
require("timo.config")
