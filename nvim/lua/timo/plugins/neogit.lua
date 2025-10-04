-- See https://github.com/NeogitOrg/neogit
return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',         -- required
      'sindrets/diffview.nvim',        -- optional - Diff integration
    },
    opts = {},
    keys = {
      { "<leader>G", desc = "Git" },

      { "<leader>Gg", function() require("neogit").open({ kind = "floating" }) end, desc = "Open neogit" },
      { "<leader>Gc", function() require("neogit").open({ 'commit' }) end, desc = "Open commit window" },
    },
  }
}
