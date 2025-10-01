return {
  {
    "williamboman/mason.nvim",
    version = "1.11.0",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    version = "1.32.0",
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
          "buf_ls",
          "clangd",
          "cssls",
          "lua_ls",
          "golangci_lint_ls",
          "gopls",
          "helm_ls",
          -- "hls",
          "html",
          -- "htmx", -- err'ed last time I wanted to try it out ...
          "jsonls",
          "jsonnet_ls",
          "marksman", -- markdown
          "pylsp",    -- python-lsp
          "pyright",
          -- "solargraph", -- For Ruby and especially GitLab development, since they have configs for it.
          "ruby_lsp",
          "rust_analyzer",
          "starlark_rust",
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

      local clangdCfg = {}
      for k, v in pairs(defaultCfg) do
        clangdCfg[k] = v
      end
      clangdCfg["filetypes"] = { "c", "cpp", "objc", "objcpp", "cuda" } -- exclude "proto".

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

      vim.lsp.config("bashls", defaultCfg)
      vim.lsp.config("buf_ls", defaultCfg)
      vim.lsp.config("clangd", clangdCfg)
      vim.lsp.config("cssls", csslsCfg)
      vim.lsp.config("lua_ls", lualsCfg)
      vim.lsp.config("golangci_lint_ls", defaultCfg)
      vim.lsp.config("gopls", defaultCfg)
      vim.lsp.config("helm_ls", helmlsCfg)
      -- lspconfig["hls"].setup(defaultCfg)
      vim.lsp.config("html", htmlCfg)
      -- lspconfig["htmx"].setup(defaultCfg)
      vim.lsp.config("jsonls", defaultCfg)
      vim.lsp.config("jsonnet_ls", defaultCfg)
      vim.lsp.config("marksman", defaultCfg)
      vim.lsp.config("pylsp", defaultCfg)
      vim.lsp.config("pyright", defaultCfg)
      -- lspconfig["solargraph"].setup(defaultCfg)
      vim.lsp.config("ruby_lsp", defaultCfg)
      vim.lsp.config("rust_analyzer", defaultCfg)
      vim.lsp.config("sqls", defaultCfg)
      vim.lsp.config("starlark_rust", defaultCfg)
      vim.lsp.config("terraformls", defaultCfg)
      vim.lsp.config("tailwindcss", defaultCfg)
      vim.lsp.config("yamlls", yamllsCfg)

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.enable("bashls")
      vim.lsp.enable("buf_ls")
      vim.lsp.enable("clangd")
      vim.lsp.enable("cssls")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("golangci_lint_ls")
      vim.lsp.enable("gopls")
      vim.lsp.enable("helm_ls")
      vim.lsp.enable("html")
      vim.lsp.enable("jsonls")
      vim.lsp.enable("jsonnet_ls")
      vim.lsp.enable("marksman")
      vim.lsp.enable("pylsp")
      vim.lsp.enable("pyright")
      vim.lsp.enable("ruby_lsp")
      vim.lsp.enable("rust_analyzer")
      vim.lsp.enable("starlark_rust")
      vim.lsp.enable("sqls")
      vim.lsp.enable("tailwindcss")
      vim.lsp.enable("terraformls")
      vim.lsp.enable("yamlls")
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {},
    keys = {
      { "<leader>k", function() require("lsp_signature").toggle_float_win() end, desc = "Toggle Signature" },
    },
  }
}
