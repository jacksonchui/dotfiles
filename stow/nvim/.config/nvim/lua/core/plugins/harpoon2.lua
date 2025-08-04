return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2", -- if you're using harpoon v2
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  config = function()
    local harpoon = require("harpoon")
    -- basic telescope configuration, that persists through instances.
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
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

    harpoon:setup() -- reloads telescope state on harpoon:setup()

    -- MARK: Functions
    vim.keymap.set("n", "<leader>m", function() harpoon:list():add() end, {desc = "[m]ark harpoon file"})
    vim.keymap.set("n", "<leader>H", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, {desc = "[h]arpoon quick [t]oggle"})
    -- vim.keymap.set("n", "<leader>M", ":Telescope harpoon marks<CR>", {desc = "Show [h]arpoon [m]arks"}) -- doesn't persist through sessions
    vim.keymap.set("n", "<leader>M", function() toggle_telescope(harpoon:list()) end,    { desc = "Open harpoon window" })

    vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<C-2>", function() harpoon:list().nav_file(2) end)
    vim.keymap.set("n", "<C-3>", function() harpoon:list().nav_file(3) end)
    vim.keymap.set("n", "<C-4>", function() harpoon:list().nav_file(4) end)
  end,
}
