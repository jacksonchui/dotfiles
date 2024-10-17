-- load package manager + packages
require('core.lazy')

-- My local config
require('core.settings')
require('core.keymaps')

-- plugins
require('core.plugins.mini_files_config') -- file explorer
require('core.plugins.harpoon')           -- Fast file switcher (C-a)
require('core.plugins.lsp')               -- lsp
require('core.plugins.noice')             -- noice (centered cmdline)
require('core.plugins.nvim-cmp')          -- autocomplete
require('core.plugins.obsidian')          -- obsidian
require('core.plugins.treesitter')        -- nav file faster
require('core.plugins.telescope')         -- fuzzy searching
require('core.plugins.ufo')               -- ufo folding
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

-- [[ Autosave, if current buffer is a file]]
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  callback = function()
    local buffer_name = vim.api.nvim_buf_get_name(0)
    if buffer_name ~= 0 and vim.bo.buflisted and not vim.bo.buftype == 'nofile' and not vim.bo.buftype == 'quickfix' then
      vim.cmd "silent w"

      local time = os.date "%I:%M %p"

      -- print nice colored msg
      vim.api.nvim_echo({ { "󰄳", "LazyProgressDone" }, { " file autosaved at " .. time } }, false, {})

      clear_cmdarea()
    end
  end,
})
