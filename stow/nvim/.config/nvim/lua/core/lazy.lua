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
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
    -- 'tpope/vim-rhubarb', -- GH Enterprise, Issues linking...
    { 'tpope/vim-fugitive',   lazy = true, },      -- :Git
    { 'tpope/vim-sleuth',                  },      -- tabstop + shiftwidth
    { 'tpope/vim-unimpaired', lazy = true, },
    { 'ahmedkhalf/project.nvim',           },
    {
        'ThePrimeagen/harpoon',
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },                       -- buffer store
    {
        'folke/zen-mode.nvim',                     -- focus mode
        cmd = { "ZenMode" },
        dependencies = {
            'folke/twilight.nvim',                 -- highlight current line
        },
    },
    {   -- amazing file tree
        'echasnovski/mini.files',
        version = false,
    },
    { -- LSP Config + Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',
            -- init these two using `opts = {}` in-line
            { 'folke/neodev.nvim',       opts = {} },                 -- lua configs for nvim...cleans up linting errors
            { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} }, -- LSP status updates
        },
        lazy = true,
    },
    {   -- TODO: Autocomplete
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',         -- LSP completion
            'rafamadriz/friendly-snippets', -- user-friendly snippets
        },
        lazy = true,
    },

    { 'folke/which-key.nvim',   opts = {} }, -- Keypress previews...
    {
        'lewis6991/gitsigns.nvim',
        opts = { -- git signs to gutter
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            on_attach = function(bufnr)
                vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
                    { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
                vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
                    { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
                vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk,
                    { buffer = bufnr, desc = '[P]review [H]unk' })
            end,
        }
    },
    { 
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
    }, -- my preferred theme
    {
        -- Lualine statusline
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }, -- add devicons plugin
        opts = {
            options = {
            icons_enabled = true,
            theme = 'catppuccin',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            },
            sections = {
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = {
                {
                'filename',
                file_status = true,
                path = 3, -- show full path with ~ for home
                shorting_target = 100,
                }
            },
            },
        },
    },
    {
      'lukas-reineke/indent-blankline.nvim',
      main = "ibl",
      opts = {
        scope = {
          highlight = {
            'RainbowViolet',
            'RainbowBlue',
            'RainbowLightYellow',
            'RainbowLightBlue',
            'WhiteSpace',
          },
        },
      },
      config = function()
        local hooks = require('ibl.hooks')

        -- Enable 'list' to show indent guides
        vim.opt.list = true

        -- Set listchars to show indent lines and trailing spaces (adjust as you like)
        vim.opt.listchars = {
          tab = '│ ',       -- vertical bar + space for tabs
          trail = '·',      -- dot for trailing spaces
          extends = '›',
          precedes = '‹',
          nbsp = '␣',
        }

        -- Define highlight groups used for rainbow indent colors
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
          vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#ccccff' })
          vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61afef' })
          vim.api.nvim_set_hl(0, 'RainbowLightYellow', { fg = '#dafdba' })
          vim.api.nvim_set_hl(0, 'RainbowLightBlue', { fg = '#dffbfc' })
          vim.api.nvim_set_hl(0, 'WhiteSpace', { fg = '#444444' })
        end)

        -- Register scope highlight (optional, for scope guides)
        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      end,
      lazy = true,
    },
    -- "gc" to comment visual regions/lines
    -- { 'numToStr/Comment.nvim', opts = {} },
    -- Faster way to navigate through files
    {
        'dmtrKovalenko/fff.nvim',
        dependencies = {
            'nvim-web-devicons',
        },
        build = "cargo +nightly build --release",
        cond = function() return vim.fn.executable 'cargo' == 1 end,
        opts = {},
        keys = {
          {
            "ff", -- try it if you didn't it is a banger keybinding for a picker
            function()
              require("fff").find_files()
            end,
            desc = "FFFind FFFiles",
          },
        },
    },
    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',         -- async, lua functions
            'debugloop/telescope-undo.nvim', -- show undo history
            'duane9/nvim-rg',                -- search with rg, not a true dep, but fits here
        },
        config = function()
            require("telescope").setup({
                extensions = {
                    undo = {}, -- telescope-undo.nvim config, see below
                },
            })
            require("telescope").load_extension("undo")
        end,
        lazy = true,
    },

    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
    },
    {
        
        'nvim-treesitter/nvim-treesitter', -- Highlight, edit, and navigate code
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
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
                end,
            },
        },
        event = "BufReadPost",
        lazy = true,
    },
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify", -- OPTIONAL: notification view
      }
    },
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      build = "cd app && yarn install",
      init = function()
        vim.g.mkdp_filetypes = { "markdown" }
      end,
      ft = { "markdown" },
    },
}, {})
