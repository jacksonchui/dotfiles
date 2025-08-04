return {
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      max_width = 100,
      render = "default",
      stages = "fade",
      timeout = 3000,
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },
}
