require("zen-mode").setup({
  window = {
    backdrop = 0.95,
    width = 80,
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
