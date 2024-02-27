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
        '--branch=stable', -- latest stable release lazypath,
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
    'tpope/vim-fugitive',                          -- :Git
    'tpope/vim-sleuth',                            -- TODO: tabstop + shiftwidth
    'theprimeagen/harpoon',                        -- buffer store
    {
        'folke/zen-mode.nvim',                     -- focus mode
        dependencies = {
            'folke/twilight.nvim',                 -- highlight current line
        },
    },
    {   -- amazing file tree
        'echasnovski/mini.files',
        version = false,
    },
    {   -- note taking
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release
        lazy = true,
        ft = "markdown",
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
        -- Theme inspired by Atom
        'navarasu/onedark.nvim',
        priority = 1000,
        config = function()
            vim.cmd.colorscheme 'onedark'
        end,
    },

    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        -- See `:help lualine.txt`
        opts = {
            options = {
                icons_enabled = false,
                theme = 'ayu_dark',
                component_separators = '|',
                section_separators = '',
            },
            sections = {
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                -- Customize the name to show file status + ~/path/to/file
                lualine_c = { { 'filename', file_status = true, path = 3 } },
            },
        },
    },

    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help ibl`
        config = function()
            local highlight = {
                'RainbowViolet',
                'RainbowBlue',
                'RainbowLightYellow',
                'RainbowLightBlue',
                'WhiteSpace',
            }

            local hooks = require('ibl.hooks')

            vim.opt.list = true
            vim.api.nvim_command([[
        set listchars=tab:\|\ ,trail:▫
      ]])

            -- appends arrow down at end of line
            -- vim.opt.listchars:append('eol:↴')

            -- create the highlight groups in the highlight setup hook, so they are reset
            -- every time the colorscheme changes
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#ccccff' })
                vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61afef' })
                vim.api.nvim_set_hl(0, 'RainbowLightYellow', { fg = '#dafdba' })
                vim.api.nvim_set_hl(0, 'RainbowLightBlue', { fg = '#dffbfc' })
            end)

            vim.g.rainbow_delimiters = { highlight = highlight }
            require('ibl').setup({
                scope = { highlight = highlight },
                whitespace = {
                    remove_blankline_trail = true,
                },
            })

            hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        end,
    },

    -- "gc" to comment visual regions/lines
    -- { 'numToStr/Comment.nvim', opts = {} },

    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',         -- async, lua functions
            'debugloop/telescope-undo.nvim', -- show undo history
        },
        config = function()
            require("telescope").setup({
                -- the rest of your telescope config goes here
                extensions = {
                    undo = {
                        -- telescope-undo.nvim config, see below
                    },
                },
            })
            require("telescope").load_extension("undo")
        end,
    },

    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
            return vim.fn.executable 'make' == 1
        end,
    },

    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },
}, {})
