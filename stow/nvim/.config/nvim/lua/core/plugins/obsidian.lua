local obsroot = os.getenv("HOME") .. "/git/obsidian/brain";

require("obsidian").setup({
    workspaces = {
        {
            name = "Notes",
            path = obsroot,
        },
    },
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
        ["<leader>of"] = {
              action = function()
                    return require("obsidian").util.gf_passthrough()
              end,
              opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes "obsidian done"
        ["<leader>od"] = {
              action = function()
                    return require("obsidian").util.toggle_checkbox()
              end,
              opts = { buffer = true },
        },
    },

    disable_frontmatter = true,

    templates = {
        subdir = "9-templates",
        date_format = "%YYYY%mm%dd",
        time_format = "%H:%M",
        tags = "",
    },
})

-- settings
vim.opt.conceallevel = 1 -- https://github.com/epwalsh/obsidian.nvim/issues/286
