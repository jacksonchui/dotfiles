return {
  {
    'echasnovski/mini.files',
    version = false,
    opts = {
      content = {
        filter = nil,
        prefix = nil,
        sort = nil,
      },
      mappings = {
        close       = 'q',
        go_in       = 'l',
        go_out      = 'h',
        reset       = '<BS>',
        reveal_cwd  = '@',
        show_help   = 'g?',
        synchronize = '=', -- insert, then sync file to create new file
        trim_left   = '<',
        trim_right  = '>',
        --go_in_plus  = 'L',
        --go_out_plus = 'H',
      },
      options = {
        permanent_delete = true,
        use_as_default_explorer = true,
      },
      windows = {
        max_number = math.huge,
        preview = false,
        width_focus = 50,
        width_nofocus = 15,
        width_preview = 25,
      },
    },
    config = function(_, opts)
      require('mini.files').setup(opts)

      -- toggle minifiles between dir for current buff and closing
      local function minifiles_toggle()
        if not MiniFiles.close() then
          MiniFiles.open(vim.loop.cwd()) -- explicitly use CWD as root
        else
          vim.api.nvim_echo({ { "MiniFiles already open" } }, false, {})
        end
      end

      vim.keymap.set('n', '<leader>pv', minifiles_toggle, { desc = '[p]re[v]iew my filetree' })
      vim.keymap.set('n', '<leader>b',  minifiles_toggle, { desc = '[p]re[v]iew my filetree' })
      vim.keymap.set('n', '<C-b>',      minifiles_toggle, { desc = '[p]re[v]iew my filetree' })
    end,
  },
}
