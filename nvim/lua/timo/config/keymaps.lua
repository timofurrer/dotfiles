local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Lazy
map("n", "<leader>L", function() require("lazy").show() end, "Show Lazy")

-- Diagnostics
map("n", "gx", vim.diagnostic.open_float, "Show diagnostics under cursor")

-- Buffers
map("n", "<leader><left>", "<cmd>bprevious<cr>", "Switch to buffer to the left")
map("n", "<leader><right>", "<cmd>bnext<cr>", "Switch to buffer to the right")
map("n", "<leader>h", "<cmd>bprevious<cr>", "Switch to buffer to the left")
map("n", "<leader>l", "<cmd>bnext<cr>", "Switch to buffer to the right")

-- Handy stuff
map("n", "<leader>X", "<cmdopen %<cr><cr>", "Open file under cursor in default app")

-- Disable arrow keys for now
map("n", "<Up>", ":echo 'No up for you!'<CR>")
map("v", "<Up>", ":<C-u>echo 'No up for you!'<CR>")
map("i", "<Up>", "<C-o>:echo 'No up for you!'<CR>")
map("n", "<Down>", ":echo 'No down for you!'<CR>")
map("v", "<Down>", ":<C-u>echo 'No down for you!'<CR>")
map("i", "<Down>", "<C-o>:echo 'No down for you!'<CR>")
map("n", "<Left>", ":echo 'No left for you!'<CR>")
map("v", "<Left>", ":<C-u>echo 'No left for you!'<CR>")
map("i", "<Left>", "<C-o>:echo 'No left for you!'<CR>")
map("n", "<Right>", ":echo 'No right for you!'<CR>")
map("v", "<Right>", ":<C-u>echo 'No right for you!'<CR>")
map("i", "<Right>", "<C-o>:echo 'No right for you!'<CR>")
map("n", "<Home>", ":echo 'No home for you!'<CR>")
map("v", "<Home>", ":<C-u>echo 'No home for you!'<CR>")
map("i", "<Home>", "<C-o>:echo 'No home for you!'<CR>")
map("n", "<End>", ":echo 'No end for you!'<CR>")
map("v", "<End>", ":<C-u>echo 'No end for you!'<CR>")
map("i", "<End>", "<C-o>:echo 'No end for you!'<CR>")
