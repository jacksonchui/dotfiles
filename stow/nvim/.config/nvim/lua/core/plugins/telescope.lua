-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
-- telescope is a tool for that leverages treesitter to display data

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false, -- don't close the whole buffer
      },
    },
  },
  pickers = {
    live_grep = {
      file_ignore_patterns = { 'node_modules', '.git', '.cpcache', '.lsp' },
      search_dirs = { root_dir },
    },
  },
}
pcall(require('telescope').load_extension, 'fzf') -- enable fzf, protected call

-- [M]odified telescope cmds
local M = {}
-- See `:help telescope.builtin`
local tb = require('telescope.builtin')
-- noremap true ensures recursion won't trigger
local function normal_leader_map(key, func, desc)
  vim.keymap.set('n', '<leader>' .. key, func, { desc = desc, noremap=true })
end

local function normal_map(key, func, desc)
  vim.keymap.set('n', key, func, { desc = desc, noremap=true })
end


M.find_files = function()
  tb.find_files {
    -- Get the list of arguments passed to Neovim
    find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden'},
    previewer = false
  }
end

M.live_grep = function()
  tb.live_grep {
    disable_coordinates = true,
    previewer = false
  }
end

-- Search vim config to find stuff
M.find_config_files = function()
  local home = os.getenv("HOME") or os.getenv("USERPROFILE")
  local config_dir = home .. '/.config/nvim'
  tb.find_files {
    find_command = { 'rg', '--follow', '--files', '--iglob', '!.git', '--hidden', config_dir },
    previewer = false
  }
end

normal_leader_map('/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, '[/] Fuzzily search in current buffer')


-- SEARCH
normal_leader_map('sd', tb.diagnostics, '[S]earch [D]iagnostics')
normal_leader_map('sh', tb.help_tags, '[S]earch [H]elp')
normal_leader_map('sk', function() tb.keymaps({ modes= {"n", "i"}}) end, '[S]earch [K]eymaps')
normal_leader_map('sv', tb.git_files, "[S]earch [V]ersion Control/Git")
normal_leader_map('sw', tb.grep_string, '[S]earch current [W]ord under cursor')
normal_leader_map('s<tab>', tb.commands, '[S]earch Commands (tab complete)')

-- SEARCH Buffers
normal_leader_map('?', tb.oldfiles, '[?] Search recently opened files')
normal_leader_map('<space>', tb.buffers, '[ ] Search existing buffers')

-- Custom Commands within 'M' Module
normal_map('<leader>C', M.find_config_files, 'Ripgrep config aka dotfiles')
normal_map('<leader>G', M.live_grep, 'Ripgrep')
-- search for files using ff from `fff`

vim.keymap.set("n", "<leader>gs", require('telescope.builtin').git_status, {desc = "[s]how git [s]tatus"})

-- Other mappings
normal_leader_map('z', require("telescope").extensions.undo.undo, "UNDO: ctrl-z")
normal_leader_map('u', function() require("telescope").extensions.undo.undo({ side_by_side = true }) end, "Show [u]ndo tree")

