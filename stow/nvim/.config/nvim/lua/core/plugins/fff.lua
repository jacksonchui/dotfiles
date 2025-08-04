-- NOTE: requires `rustup install nightly` and/or `cargo +nightly build --release`
--       to use `avx512_target_feature`, `portable_simd`, and `get_mut_unchecked`

-- [FFF]: a command that is a smarter way to search through filenames
return {
  "dmtrKovalenko/fff.nvim",  -- replace with actual repo
  dependencies = { "nvim-tree/nvim-web-devicons" },
  build = "cargo +nightly build --release",
  cond = function() return vim.fn.executable 'cargo' == 1 end,
  keys = {
    {
      "ff",
      function() require("fff").find_files() end,
      desc = "FFFind FFFiles",
    },
  },
  opts = {
    width = 0.8,
    height = 0.8,
    prompt = '🪿 ',
    preview = {
      enabled = true,
      width = 0.5,
      max_lines = 100,
      max_size = 1024 * 1024,
    },
    title = 'FFF Files',
    max_results = 60,
    max_threads = 4,
    keymaps = {
      close = '<C-c>',
      select = '<CR>',
      select_split = '<C-s>',
      select_vsplit = '<C-v>',
      select_tab = '<C-t>',
      move_up = { '<Up>', '<C-p>' },
      move_down = { '<Down>', '<C-n>' },
      preview_scroll_up = '<C-u>',
      preview_scroll_down = '<C-d>',
    },
    hl = {
      border = 'FloatBorder',
      normal = 'Normal',
      cursor = 'CursorLine',
      matched = 'IncSearch',
      title = 'Title',
      prompt = 'Question',
      active_file = 'Visual',
      frecency = 'Number',
      debug = 'Comment',
    },
    debug = {
      show_scores = false,
    },
  },
  config = function()
    require('nvim-web-devicons').setup()
  end,
}

