-- load package manager + packages
require('core.lazy')

-- My local config
require('core.settings')
require('core.keymaps')

-- plugins
require('core.plugins.mini_files_config')
require('core.plugins.harpoon') 	  -- Fast file switcher (C-a)
require('core.plugins.lsp')        	  -- lsp
require('core.plugins.nvim-cmp')          -- autocomplete
require('core.plugins.obsidian')          -- obsidian
require('core.plugins.treesitter')        -- nav file faster
require('core.plugins.telescope')         -- fuzzy searching
require('core.plugins.zenmode')           -- zenmode

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

local function clear_cmdarea()
  vim.defer_fn(function()
    vim.api.nvim_echo({}, false, {})
  end, 800)
end

-- [[ Autosave ]]
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  callback = function()
    if #vim.api.nvim_buf_get_name(0) ~= 0 and vim.bo.buflisted then
      vim.cmd "silent w"

      local time = os.date "%I:%M %p"

      -- print nice colored msg
      vim.api.nvim_echo({ { "󰄳", "LazyProgressDone" }, { " file autosaved at " .. time } }, false, {})

      clear_cmdarea()
    end
  end,
})
