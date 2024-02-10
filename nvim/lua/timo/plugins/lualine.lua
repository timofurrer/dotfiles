-- See https://github.com/nvim-lualine/lualine.nvim
return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      sections = {
        lualine_c = {
          'filename',
          {
            -- Lsp server name, from https://github.com/jpmcb/nvim-lua-conf/blob/ec6fba3ea21ed851bed5c493847e0f88152a4f03/plugin/lualine.lua#L160
            function()
              local msg = "No Active Lsp"
              local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
              local clients = vim.lsp.get_active_clients({bufnr = 0})
              if next(clients) == nil then
                return msg
              end
              local activeLsps = {}
              for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                  table.insert(activeLsps, client.name)
                end
              end
              if #activeLsps > 0 then
                return table.concat(activeLsps, ", ")
              end
              return msg
            end,
            icon = " LSP:",
            color = { fg = "#ffffff", gui = "bold" },
          }
        },
      }
    },
  }
}
