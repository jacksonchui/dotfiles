require("obsidian").setup({
    workspaces = {
        {
            name = "Notes",
            path = os.getenv("HOME") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Docs",
        },
    },
    completion = {
        nvim_cmp = true,
        min_chars = 2,
    },
    new_notes_location = "current_dir",

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

    note_frontmatter_func = function(note)
        -- This is equivalent to the default frontmatter function.
        local out = { id = note.id, aliases = note.aliases, tags = note.tags, area = "", project = "" }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

    templates = {
        subdir = "Templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
        tags = "",
    },
})

-- settings
vim.opt.conceallevel = 1 -- https://github.com/epwalsh/obsidian.nvim/issues/286
