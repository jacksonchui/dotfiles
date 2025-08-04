-- NOTE: requires `rustup install nightly` and/or `cargo +nightly build --release`
--       to use `avx512_target_feature`, `portable_simd`, and `get_mut_unchecked`

-- [FFF]: a command that is a smarter way to search through filenames
return {
  {
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
    config = function()
      require('fff').setup({
      -- UI dimensions and appearance
          width = 0.8,          -- Window width as fraction of screen
          height = 0.8,         -- Window height as fraction of screen
          prompt = '🪿 ',       -- Input prompt symbol
          preview = {
              enabled = true,
              width = 0.5,
              max_lines = 100,
              max_size = 1024 * 1024, -- 1MB
          },
          title = 'FFF Files',  -- Window title
          max_results = 60,     -- Maximum search results to display
          max_threads = 4,      -- Maximum threads for fuzzy search

          keymaps = {
            close = '<C-c>',
            select = '<CR>',
            select_split = '<C-s>',
            select_vsplit = '<C-v>',
            select_tab = '<C-t>',
            -- Multiple bindings supported
            move_up = { '<Up>', '<C-p>' },
            move_down = { '<Down>', '<C-n>' },
            preview_scroll_up = '<C-u>',
            preview_scroll_down = '<C-d>',
          },

          -- Highlight groups
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

          -- Debug options
          debug = {
            show_scores = false,  -- Toggle with F2 or :FFFDebug
          },
      })

      require('nvim-web-devicons').setup()
    end,
  },
}
