return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      -- LSP on_attach with keymaps
      local on_attach = function(_, buffer)
        local nmap = function(keys, func, desc)
          if desc then desc = "LSP: " .. desc end
          vim.keymap.set("n", keys, func, { buffer = buffer, desc = desc })
        end

        nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

        nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
        nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
        nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

        nmap("K", vim.lsp.buf.hover, "Hover Documentation for [K]eyword")
        nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation for [k]eyword")

        nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
        nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
        nmap("<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "[W]orkspace [L]ist Folders")

        vim.api.nvim_buf_create_user_command(buffer, "Format", function(_)
          vim.lsp.buf.format()
        end, { desc = "Format current buffer with LSP" })
      end

      -- Setup neodev before lspconfig
      require("neodev").setup({})

      -- Setup mason and mason-lspconfig
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "fish_lsp", "clangd", "lua_ls", "pyright", "zls" },
      })

      -- Enhance capabilities for nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local lspconfig = require("lspconfig")

      -- Lua language server config
      lspconfig.lua_ls.setup({
        Lua = {
          diagnostics = { globals = { "vim", "require" } },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME },
          },
          telemetry = { enable = false },
          completion = { callSnippet = "Replace" },
          checkThirdParty = false,
          settings = { Lua = {} },
        },
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- clangd config
      lspconfig.clangd.setup({
        cmd = {
          "clangd",
          "--all-scopes-completion",
          "--background-index",
          "--clang-tidy",
          "--completion-parse=always",
          "--completion-style=detailed",
          "--cross-file-rename",
          "--pch-storage=disk",
          "--log=error",
          "--enable-config",
          "--header-insertion=iwyu",
          "-j=4",
        },
        filetypes = { "c", "cpp", "objc" },
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- sourcekit for Swift
      lspconfig.sourcekit.setup({
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
      })
    end,
  },
}
