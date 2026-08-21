vim.g.mapleader = " "

local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<CR>")
map("n", "<leader>q", "<cmd>q<CR>")
map("n", "<leader>e", "<cmd>Neotree toggle<CR>")
map("n", "<leader>²", vim.diagnostic.goto_next)

vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")
