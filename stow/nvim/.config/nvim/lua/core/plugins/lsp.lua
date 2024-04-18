-- Must be run after loading telescope

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation for [K]eyword')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation for [k]eyword')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end

local home = os.getenv("HOME") or os.getenv("USERPROFILE")

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local server_opts_mp = {
    clangd = {
        cmd = { "clangd",
                "--all-scopes-completion",      -- Code completion from all visible scopes
                "--background-index",
                -- --compile_args_from=filesystem   -- read from filesystem instead of compile_commands.json
                "--clang-tidy",                 -- integrate checks into editor
                "--completion-parse=always",   -- always run cc, at the cost of compute
                "--completion-style=detailed",
                "--cross-file-rename",          -- lsp will apply across files, faster with --bg-index
                "--pch-storage=disk",
                "--log=error",
                "--enable-config",
                "--header-insertion=iwyu",      -- Add includes for what is used
                "-j=4",                         -- num of workers
        },
        filetypes = { "c", "cpp", "objc" },
    },
    pyright = {},
    lua_ls = {
        Lua = {
            diagnostics = { globals = { "vim " }, },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            completion = { callSnippet = "Replace" },
        },
    },
    -- https://github.com/williamboman/nvim-lsp-installer/discussions/781
    arduino_language_server = {
        cmd = {
            "arduino-language-server",
            "-cli-config",
            home .. "/Library/Arduino15/arduino-cli.yaml",
            "-cli",
            "/opt/homebrew/bin/arduino-cli",
            "-clangd",
            "/usr/bin/clangd",
            "-fqbn",
            "esp32:esp32:esp32",
        }
    },
    rust_analyzer = {},
}

-- Setup neovim lua configuration, completions for Neovim's Lua API
-- require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(server_opts_mp),
}

-- Take local `servers` and handle each one to setup
mason_lspconfig.setup_handlers {
    function(server)
        local opts = {
            capabilities = capabilities,
            on_attach = on_attach,
        }

        if not server_opts_mp[server] then
            print("Custom Opts for ".. server .." are not initialized properly.")
            return -- stop further execution to avoid errors
        end

        opts = vim.tbl_deep_extend("keep", server_opts_mp[server], opts)
        require('lspconfig')[server].setup(opts)
    end,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  command = "setlocal ts=4 sw=4 et",
})

