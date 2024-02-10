local opt = vim.opt

-- Spaces and Tabs
opt.expandtab = true   -- Use spaces instead of tabs
opt.shiftround = true  -- Round indent
opt.shiftwidth = 2     -- Indentation size
opt.smartindent = true -- Automatically indent
opt.tabstop = 2        -- Number of spaces per tab

-- Mouse
opt.mouse = "a" -- Enable mouse mode

-- Line Numbers
opt.number = true      -- Print line number
opt.relativenumber = true -- Use relative file numbers
opt.signcolumn = "yes" -- Always show the line column to not shift the text each time
opt.cursorline = true  -- Show a line on the cursor

-- Statusline
opt.laststatus = 3 -- Global statusline

-- Search
opt.smartcase = true -- Don't ignore case with capitals

-- Colors
opt.termguicolors = true -- True color support

-- Undo / Redo
opt.undofile = true
opt.undolevels = 10000

-- Show hidden characters
opt.list = true

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8
-- opt.smoothscroll = true -- Only from 0.10

-- Formatting
vim.g.autoformat = true

-- Spelling
opt.spell = true
opt.spelllang = "en_us,de_ch"

-- Concealling
opt.conceallevel = 1 -- We use this for the obsidian pluign
