-- See https://docs.gitlab.com/ee/editor_extensions/neovim/setup.html?tab=lazy.nvim
return {
  {
    'https://gitlab.com/gitlab-org/editor-extensions/gitlab.vim.git',
    branch = '129-use-feature-status-checks',
    -- Activate when a file is created/opened
    event = { 'BufReadPre', 'BufNewFile' },
    -- event = { 'VeryLazy' },
    -- Activate when a supported filetype is open
    ft = { 'go', 'javascript', 'python', 'ruby' },
    cond = function()
      -- Only activate if token is present in environment variable.
      -- Remove this line to use the interactive workflow.
      return vim.env.GITLAB_TOKEN ~= nil and vim.env.GITLAB_TOKEN ~= ''
    end,
    opts = {
			minimal_message_level = vim.log.levels.INFO,
      statusline = {
        -- Hook into the built-in statusline to indicate the status
        -- of the GitLab Duo Code Suggestions integration
        enabled = false,
      },
    },
  }
}
