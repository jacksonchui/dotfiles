local obsroot = os.getenv("HOME") .. "/Documents/obsidian-vault-zyx498";

require("obsidian").setup({
    workspaces = {
        {
            name = "main",
            path = obsroot,
        },
    },
    log_level = vim.log.levels.INFO,
    completion = {
        nvim_cmp = true,
        min_chars = 2,
    },

    -- add new links to inbox
    new_notes_location = obsroot .. "/0-inbox",

    -- Format linking
    prepend_note_id = true,     -- [[foo|Foo]]
    prepend_note_path = false, -- [[notes/foo|Foo]]
    use_path_only = false,      -- [[notes/foo]]

    mappings = {
        -- "Obsidian follow"
        ["<leader>gd"] = {
              action = function()
                    return require("obsidian").util.gf_passthrough()
              end,
              opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes "obsidian done"
        ["<leader>ch"] = {
              action = function()
                    return require("obsidian").util.toggle_checkbox()
              end,
              opts = { buffer = true },
        },
        -- "Obsidian search files"
        ["<leader>sf"] = {
            action = function()
                return vim.cmd("ObsidianQuickSwitch")
            end,
            opts = { buffer = true },
        },
        -- "Obsidian search grep
        ["<leader>sg"] = {
            action = function()
                return vim.cmd("ObsidianSwitch")
            end,
            opts = { buffer = true },
        },
    },
    disable_frontmatter = true,
    preferred_link_style = "markdown",
    sort_by = "modified",
    open_notes_in = "vsplit",
})

-- settings
vim.opt.conceallevel = 1 -- https://github.com/epwalsh/obsidian.nvim/issues/286
