-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false, -- don't close the whole buffer
      },
    },
  },
}


local M = {}

function M.GetOpenedDirectory()
  local args = vim.fn.argv()
  if #args > 0 and vim.fn.isdirectory(args[1]) == 1 then
    return args[1]
  end
  return nil
end

M.find_files = function()
  require('telescope.builtin').find_files {
    -- Get the list of arguments passed to Neovim
    find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden', M.GetOpenedDirectory()},
    previewer = false
  }
end

-- Search vim config to find stuff
M.find_config_files = function()
  local home = os.getenv("HOME") or os.getenv("USERPROFILE")
  local config_dir = home .. '/.config/nvim'
  require("telescope.builtin").find_files {
    find_command = { 'rg', '--follow', '--files', '--iglob', '!.git', '--hidden', config_dir },
    previewer = false
  }
end

-- Enable telescope fzf native, if installed (protected call)
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', M.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sc', M.find_config_files, { desc = '[S]earch [C]onfig files for docs' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord under cursor' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set("n", "<leader>z", "<cmd>Telescope undo<cr>", {desc = "Is ctrl-z"})
vim.keymap.set("n", "<leader>u", function() require("telescope").extensions.undo.undo({ side_by_side = true }) end, {desc = "Show [u]ndo tree"})

