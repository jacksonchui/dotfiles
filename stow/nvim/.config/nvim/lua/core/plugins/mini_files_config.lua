-- No need to copy this inside `setup()`. Will be used automatically.
require('mini.files').setup({
  -- Customization of shown content
  content = {
    -- Predicate for which file system entries to show
    filter = nil,
    -- What prefix to show to the left of file system entry
    prefix = nil,
    -- In which order to show file system entries
    sort = nil,
  },

  -- Module mappings created only inside explorer.
  -- Use `''` (empty string) to not create one.
  mappings = {
    close       = 'q',
    go_in       = 'l',
    go_out      = 'h',
    reset       = '<BS>',
    reveal_cwd  = '@',
    show_help   = 'g?',
    synchronize = '=', -- insert, then sync file to create new file
    trim_left   = '<', -- reduces the available window size
    trim_right  = '>',
    --go_in_plus  = 'L',
    --go_out_plus = 'H',
  },

  -- General options
  options = {
    -- Whether to delete permanently or move into module-specific trash
    permanent_delete = true,
    -- Whether to use for editing directories
    use_as_default_explorer = true,
  },

  -- Customization of explorer windows
  windows = {
    -- Maximum number of windows to show side by side
    max_number = math.huge,
    -- Whether to show preview of file/directory under cursor
    preview = false,
    -- Width of focused window
    width_focus = 50,
    -- Width of non-focused window
    width_nofocus = 15,
    -- Width of preview window
    width_preview = 25,
  },
}) -- end of require('mini.files')

vim.keymap.set('n', '<leader>pv', MiniFiles.open, { desc = '[p]re[v]iew my filetree' })
vim.keymap.set('n', '<leader>b', MiniFiles.open, { desc = '[p]re[v]iew my filetree' })
vim.keymap.set('n', '<C-b>', MiniFiles.open, { desc = '[p]re[v]iew my filetree' })

