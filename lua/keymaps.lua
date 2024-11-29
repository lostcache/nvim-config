local vim = vim

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Basic Keymaps ]]

local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.keymap.set

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)

-- navigate splits
keymap("n", "<leader>h", "<C-w>h", opts)
keymap("n", "<leader>j", "<C-w>j", opts)
keymap("n", "<leader>k", "<C-w>k", opts)
keymap("n", "<leader>l", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Press jk to exit insert mode
keymap("i", "jk", "<ESC>", opts)

-- clear highlights
keymap("n", "<leader>n", ":nohl<CR>", opts)

-- Diagnostics
keymap("n", "<leader>d", ":Trouble diagnostics toggle focus=true filter.buf=0<cr><cr>", opts)

-- go normal mode in terminal
keymap("t", "jk", [[<C-\><C-n>]], opts)

-- project picker
keymap("n", "<leader>p", "lua require('telescope').extensions.project.project{}<CR>", opts)
