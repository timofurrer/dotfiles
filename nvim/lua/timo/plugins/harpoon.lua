-- See https://github.com/ThePrimeagen/harpoon/tree/harpoon2
-- basic telescope configuration
local function toggle_telescope(harpoon_files)
    local conf = require("telescope.config").values

    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
    end,
    keys = {
      { "<leader>a", desc = "Harpoon" },
      { "<leader>aa", function() require("harpoon"):list():append() end, desc = "Append to harpoon list" },
      { "<leader>al", function() toggle_telescope(require("harpoon"):list()) end, desc = "Open harpoon window" },
      { "<leader>1", function() require("harpoon"):list():select(1) end, "harpoon to 1"},
      { "<leader>2", function() require("harpoon"):list():select(2) end, "harpoon to 2"},
      { "<leader>3", function() require("harpoon"):list():select(3) end, "harpoon to 3"},
      { "<leader>4", function() require("harpoon"):list():select(4) end, "harpoon to 4"},
      { "<leader>ap", function() require("harpoon"):list():prev() end, "harpoon to previous"},
      { "<leader>an", function() require("harpoon"):list():next() end, "harpoon to next"},
    }
  }
}
