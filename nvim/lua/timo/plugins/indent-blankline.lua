-- See https://github.com/lukas-reineke/indent-blankline.nvim
return {
   {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = {"VeryLazy"},
    opts = {
      exclude = {
        filetypes = {'dashboard'},
      },
      indent = { char = '┊' },
      whitespace = {
        remove_blankline_trail = false,
      },
    },
  },
}
