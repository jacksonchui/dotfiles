-- load package manager + packages
require('core.lazy')

-- My local config
require('core.settings')
require('core.keymaps')

-- plugins
require('core.plugins.mini_files_config')
require('core.plugins.harpoon') 	  -- Fast file switcher (C-a)
require('core.plugins.treesitter')        -- nav file faster
require('core.plugins.telescope')         -- fuzzy searching
require('core.plugins.lsp')        	  -- lsp
require('core.plugins.nvim-cmp')          -- autocomplete

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})
