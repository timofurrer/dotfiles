-- See https://github.com/nvimdev/dashboard-nvim
return {
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    opts = {
      config = {
        header = {
          '',
          '',
          '',
          '._______________________.',
          '|TFTFTFTFTFTFTFTFTFTFTFT|',
          '     |TFT|      |TFT|    ',
          '     |TFT|   .__|TFT|__. ',
          '     |TFT|   |TFTFTFTFT| ',
          '     |TFT|      |TFT|    ',
          '     |TFT|      |TFT|    ',
          '     |TFT|      |TFT|    ',
          '     |TFT|      |TFT|    ',
          '',
          '',
        },
        footer = {''},
      },
    },
    dependencies = { {'nvim-tree/nvim-web-devicons'}}
  }
}
