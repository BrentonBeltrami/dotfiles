-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local wk = require("which-key")

vim.api.nvim_set_keymap("n", "<C-f>", ":silent !tmux neww tmux-sessionizer<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-t>", ":silent !tmux neww todo-toolbar<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-n>", ":silent !tmux neww journal<CR>", { silent = true })

wk.register({
  z = { name = "Zen Mode", m = { "<cmd>ZenMode<CR>", "Zen mode" } },
}, { prefix = "<leader>" })
