-- 1. My config for vanilla nvim, keybinds
require('core.settings')
require('core.keymaps')

-- load package manager + packages
-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
	lazypath
    }
end

-- proritize runtime path searches in lazy directory for docs
vim.opt.rtp:prepend(lazypath)
-- this will pull from all the files within the `core.plugins` folder
require('lazy').setup('core.plugins')

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
