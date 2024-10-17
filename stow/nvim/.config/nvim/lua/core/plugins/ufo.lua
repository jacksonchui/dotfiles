vim.o.fillchars = [[eob: ,fold: ,foldopen:▼,foldsep: ,foldclose:⏵]]
vim.o.foldcolumn = '2' -- How wide the fold column is
vim.o.foldlevel = 99 -- initial large value so everything open by default
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Keymaps necessary to generate folds for UFO
vim.keymap.set("n", "zM", require("ufo").closeAllFolds, {desc="close all folds" })
vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc="open all folds" })

require('ufo').setup({
    provider_selector = function()
        return { "treesitter", "indent" }
      end,

})
