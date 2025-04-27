-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Default options for keymaps
local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.keymap.set

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap space as leader key (redundant with line 5, but keeping for compatibility)
keymap("", "<Space>", "<Nop>", opts)

-- Window navigation
keymap("n", "<leader>h", "<C-w>h", opts)
keymap("n", "<leader>j", "<C-w>j", opts)
keymap("n", "<leader>k", "<C-w>k", opts)
keymap("n", "<leader>l", "<C-w>l", opts)

-- Window resizing
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Quick escape from insert mode
keymap("i", "jk", "<ESC>", opts)

-- Clear search highlights
keymap("n", "<leader>n", ":nohl<CR>", opts)

-- Toggle diagnostics
keymap("n", "<leader>d", ":Trouble diagnostics toggle focus=true filter.buf=0<cr>", opts)

-- Exit terminal mode
keymap("t", "jk", [[<C-\><C-n>]], opts)

-- Open project picker
keymap("n", "<leader>pp", ":lua require('telescope').extensions.project.project{}<CR>", opts)

-- Save file
keymap("n", "<leader>w", ":w<CR>", opts)

-- Close buffer
keymap("n", "<leader>c", ":bd<CR>", opts)

-- Move selected lines up and down in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)
