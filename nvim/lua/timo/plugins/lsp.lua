return {
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      { "williamboman/mason.nvim" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "clangd",
          "cssls",
          "lua_ls",
          "golangci_lint_ls",
          "gopls",
          "helm_ls",
          "hls",
          "html",
          -- "htmx", -- err'ed last time I wanted to try it out ...
          "jsonls",
          "jsonnet_ls",
          "marksman", -- markdown
          "pylsp",    -- python-lsp
          "pyright",
          -- "solargraph", -- For Ruby and especially GitLab development, since they have configs for it.
          "ruby_lsp",
          "sqls",
          "tailwindcss",
          "terraformls",
          "yamlls",
        },
      })

      -- Diagnostic config
      local config = {
        virtual_text = {
          severity = vim.diagnostic.severity.ERROR,
          spacing = 8,
          format = function(value)
            return string.format('%s: [%s] %s', value.source, value.code, value.message)
          end,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      }
      vim.diagnostic.config(config)

      -- This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(client, bufnr)
        local lsp_map = function(lhs, rhs, bufnr, desc)
          vim.keymap.set("n", lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
        end

        lsp_map("<leader>lr", vim.lsp.buf.rename, bufnr, "Rename symbol")
        lsp_map("<leader>la", vim.lsp.buf.code_action, bufnr, "Code action")
        lsp_map("<leader>ld", vim.lsp.buf.type_definition, bufnr, "Type definition")
        lsp_map("<leader>ls", require("telescope.builtin").lsp_document_symbols, bufnr, "Document symbols")

        lsp_map("gd", require("telescope.builtin").lsp_definitions, bufnr, "Goto Definition")
        lsp_map("gr", require("telescope.builtin").lsp_references, bufnr, "Goto References")
        lsp_map("gI", require("telescope.builtin").lsp_implementations, bufnr, "Goto Implementation")
        lsp_map("K", vim.lsp.buf.hover, bufnr, "Hover Documentation")
        lsp_map("gD", vim.lsp.buf.declaration, bufnr, "Goto Declaration")
        lsp_map("gH", vim.lsp.buf.hover, bufnr, "Hover")
        lsp_map("gX", require("telescope.builtin").diagnostics, bufnr, "Show diagnostics for open buffer")

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
          vim.lsp.buf.format()
        end, { desc = "Format current buffer with LSP" })

        lsp_map("<leader>fo", "<cmd>Format<cr>", bufnr, "Format")
      end

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local defaultCfg = {
        on_attach = on_attach,
        capabilities = capabilities,
      }
      local lspconfig = require("lspconfig")

      local helmlsCfg = {}
      for k, v in pairs(defaultCfg) do
        helmlsCfg[k] = v
      end
      helmlsCfg["settings"] = {
        ["helm-ls"] = {
          yamlls = {
            path = "yaml-language-server",
          },
        },
      }

      local yamllsCfg = {}
      for k, v in pairs(defaultCfg) do
        yamllsCfg[k] = v
      end
      yamllsCfg["settings"] = {
        yaml = {
          schemas = {
            ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] =
            "/.gitlab-ci.yml",
            ["https://gitlab.com/gitlab-org/cluster-integration/gitlab-agent/-/raw/master/pkg/agentcfg/agentcfg_schemas/ConfigurationFile.json"] =
            "/.gitlab/agents/*/config.yaml",
          },
        },
      }

      local lualsCfg = {}
      for k, v in pairs(defaultCfg) do
        lualsCfg[k] = v
      end
      lualsCfg["settings"] = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          }
        }
      }

      --Enable (broadcasting) snippet capability for completion
      local htmlCapabilities = vim.lsp.protocol.make_client_capabilities()
      htmlCapabilities.textDocument.completion.completionItem.snippetSupport = true
      local htmlCfg = {}
      for k, v in pairs(defaultCfg) do
        htmlCfg[k] = v
      end
      htmlCfg["capabilities"] = htmlCapabilities

      --Enable (broadcasting) snippet capability for completion
      local cssCapabilities = vim.lsp.protocol.make_client_capabilities()
      cssCapabilities.textDocument.completion.completionItem.snippetSupport = true
      local csslsCfg = {}
      for k, v in pairs(defaultCfg) do
        csslsCfg[k] = v
      end
      csslsCfg["capabilities"] = cssCapabilities

      lspconfig["bashls"].setup(defaultCfg)
      lspconfig["clangd"].setup(defaultCfg)
      lspconfig["cssls"].setup(csslsCfg)
      lspconfig["lua_ls"].setup(lualsCfg)
      lspconfig["golangci_lint_ls"].setup(defaultCfg)
      lspconfig["gopls"].setup(defaultCfg)
      lspconfig["helm_ls"].setup(helmlsCfg)
      lspconfig["hls"].setup(defaultCfg)
      lspconfig["html"].setup(htmlCfg)
      -- lspconfig["htmx"].setup(defaultCfg)
      lspconfig["jsonls"].setup(defaultCfg)
      lspconfig["jsonnet_ls"].setup(defaultCfg)
      lspconfig["marksman"].setup(defaultCfg)
      lspconfig["pylsp"].setup(defaultCfg)
      lspconfig["pyright"].setup(defaultCfg)
      -- lspconfig["solargraph"].setup(defaultCfg)
      lspconfig["ruby_lsp"].setup(defaultCfg)
      lspconfig["sqls"].setup(defaultCfg)
      lspconfig["terraformls"].setup(defaultCfg)
      lspconfig["tailwindcss"].setup(defaultCfg)
      lspconfig["yamlls"].setup(yamllsCfg)
    end,
  },
}
