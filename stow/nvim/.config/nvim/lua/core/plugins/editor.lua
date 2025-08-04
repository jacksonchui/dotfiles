return {
    { 'tpope/vim-sleuth' }, -- indent and newlines
    { 'tpope/vim-unimpaired', lazy = true }, -- bracket commands
    { 'ahmedkhalf/project.nvim',
      event = "BufEnter",
      opts = {
        manual_mode = false,           -- Automatic root detection
        detection_methods = { "lsp", "pattern" }, -- Fallback order
        patterns = { ".git", "Makefile", "package.json" },
        silent_chdir = false,          -- Show a message when directory changes
        scope_chdir = "global",        -- Change cwd globally, but can be "tab" or "win"
        ignore_lsp = {},
        exclude_dirs = {},
        datapath = vim.fn.stdpath("data"),
      },
      config = function(_, opts)
        require("project_nvim").setup(opts)
        -- Optionally integrate with Telescope
        pcall(require("telescope").load_extension, "projects")
      end,
    },
    { 'folke/which-key.nvim',   opts = {} }, -- Keypress previews...
    { 'lukas-reineke/indent-blankline.nvim',
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
    { 'iamcco/markdown-preview.nvim',
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      build = "cd app && yarn install",
      cond = function() return vim.fn.executable 'yarn' == 1 end,
      init = function()
        vim.g.mkdp_filetypes = { "markdown" }
      end,
      ft = { "markdown" },
    },
    { 'folke/zen-mode.nvim', -- focus mode
      cmd = { "ZenMode" }, -- lazy load on ZenMode
      dependencies = { 'folke/twilight.nvim' }, -- highlight current line
      config = function()
        require("zen-mode").setup({
          window = {
            backdrop = 0.95,
            width = 120,
            height = 1,
            options = {
              signcolumn = "no",
              number = false,
              relativenumber = false,
            },
          },
          plugins = {
            options = {
              enabled = true,
              ruler = false, -- disables ruler text in cmd line area
              number = true, -- disable number column
              relativenumber = true, -- disable relative numbers
              cursorline = true,
              showcmd = false, -- disables command in last line of screen
              -- laststatus = 0, -- turn off status line, only shows if 3
            },
            twilight = { enabled = true },
            gitsigns = { enabled = false },
            tmux = { enabled = true },
            wezterm = {
              enabled = true,
              font = "+20", -- (10% increase per step)
            },
          },
        });
      end,
    }
}