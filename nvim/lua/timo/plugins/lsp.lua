-------- The code below is apparently necessary until I'm using nvim 0.10.0.
-- See https://shopify.github.io/ruby-lsp/EDITORS_md.html#label-Neovim+LSP

-- textDocument/diagnostic support until 0.10.0 is released
_timers = {}
local function setup_diagnostics(client, buffer)
  if require("vim.lsp.diagnostic")._enable then
    return
  end

  local diagnostic_handler = function()
    local params = vim.lsp.util.make_text_document_params(buffer)
    client.request("textDocument/diagnostic", { textDocument = params }, function(err, result)
      if err then
        local err_msg = string.format("diagnostics error - %s", vim.inspect(err))
        vim.lsp.log.error(err_msg)
      end
      local diagnostic_items = {}
      if result then
        diagnostic_items = result.items
      end
      vim.lsp.diagnostic.on_publish_diagnostics(
        nil,
        vim.tbl_extend("keep", params, { diagnostics = diagnostic_items }),
        { client_id = client.id }
      )
    end)
  end

  diagnostic_handler() -- to request diagnostics on buffer when first attaching

  vim.api.nvim_buf_attach(buffer, false, {
    on_lines = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
      _timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
    end,
    on_detach = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
    end,
  })
end

-- adds ShowRubyDeps command to show dependencies in the quickfix list.
-- add the `all` argument to show indirect dependencies as well
local function add_ruby_deps_command(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "ShowRubyDeps",
                                          function(opts)

        local params = vim.lsp.util.make_text_document_params()

        local showAll = opts.args == "all"

        client.request("rubyLsp/workspace/dependencies", params,
                        function(error, result)
            if error then
                print("Error showing deps: " .. error)
                return
            end

            local qf_list = {}
            for _, item in ipairs(result) do
                if showAll or item.dependency then
                    table.insert(qf_list, {
                        text = string.format("%s (%s) - %s",
                                              item.name,
                                              item.version,
                                              item.dependency),

                        filename = item.path
                    })
                end
            end

            vim.fn.setqflist(qf_list)
            vim.cmd('copen')
        end, bufnr)
    end, {nargs = "?", complete = function()
        return {"all"}
    end})
end

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
          "lua_ls",
          "golangci_lint_ls",
          "gopls",
          "helm_ls",
          "hls",
          "jsonls",
          "jsonnet_ls",
          "marksman", -- markdown
          "pylsp", -- python-lsp
          "pyright",
          -- "solargraph", -- For Ruby and especially GitLab development, since they have configs for it.
          "ruby_ls",
          "terraformls",
          "tsserver",
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
        lsp_map("gX", require("telescope.builtin").diangostics, bufnr, "Show diagnostics for open buffer")

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
        helmlsCfg[k] =v
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
            ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "/.gitlab-ci.yml",
            ["https://gitlab.com/gitlab-org/cluster-integration/gitlab-agent/-/raw/master/pkg/agentcfg/agentcfg_schemas/ConfigurationFile.json"] = "/.gitlab/agents/*/config.yaml",
          },
        },
      }

      local rubylsCfg = {}
      for k, v in pairs(defaultCfg) do
        rubylsCfg[k] = v
      end

      rubylsCfg["on_attach"] = function(client, buffer)
        on_attach(client, buffer)
        setup_diagnostics(client, buffer)
        add_ruby_deps_command(client, buffer)
      end,

      lspconfig["lua_ls"].setup(defaultCfg)
      lspconfig["golangci_lint_ls"].setup(defaultCfg)
      lspconfig["gopls"].setup(defaultCfg)
      lspconfig["helm_ls"].setup(helmlsCfg)
      lspconfig["hls"].setup(defaultCfg)
      lspconfig["jsonls"].setup(defaultCfg)
      lspconfig["jsonnet_ls"].setup(defaultCfg)
      lspconfig["marksman"].setup(defaultCfg)
      lspconfig["pylsp"].setup(defaultCfg)
      lspconfig["pyright"].setup(defaultCfg)
      -- lspconfig["solargraph"].setup(defaultCfg)
      lspconfig["ruby_ls"].setup(rubylsCfg)
      lspconfig["terraformls"].setup(defaultCfg)
      lspconfig["yamlls"].setup(yamllsCfg)
    end,
  },
}
