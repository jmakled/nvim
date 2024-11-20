-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Usual syntax is vim.keymap.set(<mode>, <key>, <action>, <opts>)
-- NOTE: Per-plugin keymaps oughta go in lua/plugins/*.lua with the rest of the plugin config

-- slimming down the set declaration
local map = vim.keymap.set

-- slimming down the options
local opts = { noremap = true, silent = true }

-- General
map("i", "jk", "<Esc>", opts)

-- Saving & Quitting
map("n", "<leader>x", ":x<CR>", opts)
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>Q", ":qa<CR>", opts)

-- Buffers
map("n", "<S-h>", ":bprev<CR>", opts)
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<leader>bd", ":bdelete<CR>", opts)

-- Splits
map("n", "<leader>v", ":vsplit<CR>", opts)
map("n", "<leader>h", ":hsplit<CR>", opts)
