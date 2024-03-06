-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.o.clipboard = 'unnamedplus'
-- Keep the system clipboard separate
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move Rows together (just highlight in visual)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'In visual, move rows together' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z", { desc = '[J] or Replace newline with space' })
vim.keymap.set("n", "n", "nzzzv", { desc = 'Keep cursor in middle when searching with /' })
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever...keep the old buffer when pasting over
vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set("n", "Q", "<nop>", { desc = 'Dont press Q...just dont' })
vim.keymap.set("n", "QQ", ":qa!<enter>", { desc = 'Force Quit' })
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = 'Control-c or escape to escape buffers lol' })
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'escape (doesn\'t work in pop ups)' });

-- buffer management
vim.keymap.set("n", "tk", ":bnext<enter>", {noremap=false});
vim.keymap.set("n", "tj", ":bprev<enter>", {noremap=false});
vim.keymap.set("n", "th", ":bfirst<enter>", {noremap=false});
vim.keymap.set("n", "tl", ":blast<enter>", {noremap=false});
vim.keymap.set("n", "B", "^", {silent=true, noremap=true});

-- Swap between projects ... opens git projects as tmux sessions
-- https://github.com/jrmoulton/tmux-sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Script stuff
vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = '[S]ubstitute the current word' })
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- insert mode
