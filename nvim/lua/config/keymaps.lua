-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local wk = require("which-key")
wk.register({
  n = {
    name = "Telekasten",
    n = { "<cmd>Telekasten new_note<cr>", "new note" },
    t = { "<cmd>Telekasten goto_today<cr>", "daily note" },
    w = { "<cmd>Telekasten goto_thisweek<cr>", "weekly note" },
    d = { "<cmd>Telekasten find_daily_notes<cr>", "find daily notes" },
    p = { "<cmd>Telekasten panel<cr>", "panel" },
    f = { "<cmd>Telekasten follow_link<cr>", "follow link" },
    b = { "<cmd>Telekasten show_backlinks<cr>", "show backlinks" },
  },
}, { prefix = "<leader>" })

vim.keymap.set("n", "c", '"_c')
vim.keymap.set("n", "C", '"_C')

vim.api.nvim_set_keymap("n", "<C-f>", ":silent !tmux neww tmux-sessionizer<CR>", { silent = true })

local cmp = require("cmp")
cmp.setup({
  mapping = {
    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  },
})

-- local breadcrumbs = require("breadcrumbs")
-- -- Toggle breadcrumbs and do.nvim
-- wk.register({
--   function()
--     if breadcrumbs.active == true then
--       breadcrumbs.active = false
--       vim.api.nvim_command("DoShow")
--     else
--       breadcrumbs.active = true
--       vim.api.nvim_command("DoHide")
--     end
--   end,
-- }, { prefix = "<leader>" })
--
wk.register({
  z = {
    name = "Zen Mode",
    m = { "<cmd>ZenMode<CR>", "Zen mode" },
  },
}, { prefix = "<leader>" })
