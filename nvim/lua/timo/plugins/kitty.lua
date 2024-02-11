-- See https://github.com/fladson/vim-kitty
return {
  {
    'fladson/vim-kitty',
    lazy = true,
    event = {
      "BufReadPre kitty.conf,*/kitty/kitty/*.conf",
      "BufNewFile kitty.conf,*/kitty/kitty/*.conf",
    },
    config = function() end,
  }
}
