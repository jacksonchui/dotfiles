local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>m", mark.add_file, {desc = "[m]ark harpoon file"})
vim.keymap.set("n", "<leader>ht", ui.toggle_quick_menu, {desc = "[h]arpoon quick [t]oggle"})
vim.keymap.set("n", "<leader>hm", ":Telescope harpoon marks<CR>", {desc = "Show [h]arpoon [m]arks"})
vim.keymap.set("n", "<leader>gs", require('telescope.builtin').git_status, {desc = "[s]how git [s]tatus"})
vim.keymap.set("n", "<C-1>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-2>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-3>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-4>", function() ui.nav_file(4) end)

