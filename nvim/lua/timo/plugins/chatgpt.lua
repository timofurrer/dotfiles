-- See https://github.com/jackMort/ChatGPT.nvim
return {
  {
    "jackMort/ChatGPT.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      local model = "gpt-4"
      require("chatgpt").setup({
        -- Read API key from 1Password in Personal -> OpenAPI -> credential [the field]
        api_key_cmd = "op read op://personal/OpenAPI/credential --no-newline",
        -- Use another model
        openai_params = {
          model = model,
        },
        openai_edit_params = {
          model = model,
        },
      })
    end,
    keys = {
      { "<leader>c", desc = "ChatGPT" },
      { "<leader>cc", "<cmd>ChatGPT<cr>", desc = "ChatGPT" },
      { "<leader>ca", "<cmd>ChatGPTAcAs", desc = "Act as ..." },
      { "<leader>ce", "<cmd>ChatGPTEditWithInstruction", desc = "Edit with instruction", mode = { "n", "v" }},
      { "<leader>cg", "<cmd>ChatGPTRun grammar_correction<cr>", desc = "Grammar Correction", mode = { "n", "v" } },
      { "<leader>ct", "<cmd>ChatGPTRun translate<cr>", desc = "Translate", mode = { "n", "v" } },
      { "<leader>ck", "<cmd>ChatGPTRun keywords<cr>", desc = "Keywords", mode = { "n", "v" } },
      { "<leader>cd", "<cmd>ChatGPTRun docstring<cr>", desc = "Docstring", mode = { "n", "v" } },
      { "<leader>cv", "<cmd>ChatGPTRun add_tests<cr>", desc = "Add Tests", mode = { "n", "v" } },
      { "<leader>co", "<cmd>ChatGPTRun optimize_code<cr>", desc = "Optimize Code", mode = { "n", "v" } },
      { "<leader>cs", "<cmd>ChatGPTRun summarize<cr>", desc = "Summarize", mode = { "n", "v" } },
      { "<leader>cf", "<cmd>ChatGPTRun fix_bugs<cr>", desc = "Fix Bugs", mode = { "n", "v" } },
      { "<leader>cx", "<cmd>ChatGPTRun explain_code<cr>", desc = "Explain Code", mode = { "n", "v" } },
      { "<leader>cr", "<cmd>ChatGPTRun roxygen_edit<cr>", desc = "Roxygen Edit", mode = { "n", "v" } },
      { "<leader>cl", "<cmd>ChatGPTRun code_readability_analysis<cr>", desc = "Code Readability Analysis", mode = { "n", "v" } },
    },
  }
}
