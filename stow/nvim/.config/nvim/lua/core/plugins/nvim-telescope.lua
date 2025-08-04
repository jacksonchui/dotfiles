return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim', -- for fzf extension
      'debugloop/telescope-undo.nvim',             -- for undo extension
    },
    opts = function()
      local root_dir = vim.loop.cwd() -- or any other logic for root_dir

      return {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
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
    end,
    config = function(_, opts)
      local telescope = require('telescope')
      telescope.setup(opts)
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'undo')

      local tb = require('telescope.builtin')

      -- Helper functions for mapping
      local function normal_leader_map(key, func, desc)
        vim.keymap.set('n', '<leader>' .. key, func, { desc = desc, noremap = true })
      end

      local function normal_map(key, func, desc)
        vim.keymap.set('n', key, func, { desc = desc, noremap = true })
      end

      -- Custom commands
      local M = {}

      M.find_files = function()
        tb.find_files {
          find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
          previewer = false,
        }
      end

      M.live_grep = function()
        tb.live_grep {
          disable_coordinates = true,
          previewer = false,
        }
      end

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
      normal_leader_map('sc', M.find_config_files, '[S]earch my [C]onfig')
      normal_leader_map('sf', M.find_files, '[S]earch [F]iles')
      normal_leader_map('sg', M.live_grep, '[S]earch by [G]rep')

      -- Other mappings
      normal_leader_map('z', require("telescope").extensions.undo.undo, "UNDO: ctrl-z")
      normal_leader_map('u', function() require("telescope").extensions.undo.undo({ side_by_side = true }) end, "Show [u]ndo tree")
    end,
  },
  {
    -- better folds
    'kevinhwang91/nvim-ufo',
    dependencies = {
        'kevinhwang91/promise-async',
        {
            "luukvbaal/statuscol.nvim",
            config = function()
              local builtin = require("statuscol.builtin")
              require("statuscol").setup({
                relculright = true,
                segments = {
                  { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
                  { text = { "%s" }, click = "v:lua.ScSa" },
                  { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
                },
              })
              vim.o.fillchars = [[eob: ,fold: ,foldopen:▼,foldsep: ,foldclose:⏵]]
              vim.o.foldcolumn = '2' -- How wide the fold column is
              vim.o.foldlevel = 99 -- initial large value so everything open by default
              vim.o.foldlevelstart = 99
              vim.o.foldenable = true

              -- Keymaps necessary to generate folds for UFO
              vim.keymap.set("n", "zM", require("ufo").closeAllFolds, {desc="close all folds" })
              vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc="open all folds" })

              require('ufo').setup({
                  provider_selector = function()
                      return { "treesitter", "indent" }
                    end,
              })
            end,
        },
    },
    event = "BufReadPost",
    lazy = true,
  },
}