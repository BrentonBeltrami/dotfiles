-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
-- TODO: Fix yank going to clipboard

-- NOTE: Essentials
lvim.log.level = "warn"
-- unfuck escape
lvim.keys.insert_mode["<A-j>"] = false
lvim.keys.insert_mode["<A-k>"] = false
lvim.keys.normal_mode["<A-j>"] = false
lvim.keys.normal_mode["<A-k>"] = false
lvim.keys.visual_block_mode["<A-j>"] = false
lvim.keys.visual_block_mode["<A-k>"] = false
lvim.keys.visual_block_mode["J"] = false
lvim.keys.visual_block_mode["K"] = false

-- unfuck registers
-- vim.clipboard = "unnamed"

-- unfuck scroll

-- Change operations go to blackhole register
vim.keymap.set('n', 'c', '"_c')
vim.keymap.set('n', 'C', '"_C')

-- relativenumber
vim.opt.nu = true
vim.opt.relativenumber = true

-- linters & formatters
lvim.format_on_save.enabled = true
vim.cmd('syntax enable')
local linters = require "lvim.lsp.null-ls.linters"
local formatters = require "lvim.lsp.null-ls.formatters"
linters.setup {
  {
    command = "eslint_d",
    filetypes = { "typescript" },
  },
  {
    command = "vale",
    filetypes = { "markdown" },
  },

}
formatters.setup {
  {
    command = "eslint_d",
    filetypes = { "typescript" },
  },
  {
    command = "prettier",
    filetypes = {
      "javascript", "javascriptreact", "typescript", "typescriptreact", "html", "json", "jsonc", "yaml", "markdown",
      "markdown.mdx",
    },
  },
}

-- trouble
lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>TroubleToggle<cr>", "trouble" },
  w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
  d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
  q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
  l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

-- telescope
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "yaml",
}

-- NOTE: Web Dev
-- emmet leader key
vim.g['user_emmet_leader_key'] = ','

-- NOTE: Zettelkasten
-- vim.opt.spelllang = 'en_us'
-- vim.opt.spell = true
local home = vim.fn.expand("~/zettelkasten")
-- Telekasten remaps -- https://github.com/renerocksai/telekasten.nvim#0-install-and-setup
lvim.builtin.which_key.mappings["n"] = {
  name = "Telekasten",
  n = { "<cmd>Telekasten new_note<cr>", "new note" },
  t = { "<cmd>Telekasten goto_today<cr>", "daily note" },
  w = { "<cmd>Telekasten goto_thisweek<cr>", "weekly note" },
  d = { "<cmd>Telekasten find_daily_notes<cr>", "find daily notes" },
  p = { "<cmd>Telekasten panel<cr>", "panel" },
  f = { "<cmd>Telekasten follow_link<cr>", "follow link" },
  b = { "<cmd>Telekasten show_backlinks<cr>", "show backlinks" },
}
-- Call insert link automatically when we start typing a link
vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")
-- zenmode
lvim.builtin.which_key.mappings["z"] = {
  name = "Zen Mode",
  m = { "<cmd>ZenMode<CR>", "Zen mode" },
}

-- NOTE: Plugins
lvim.plugins = {
  -- Essentials
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    'christoomey/vim-tmux-navigator',
    lazy = false
  },
  { 'nvim-treesitter/nvim-treesitter-context' },
  -- debugging
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui" },
  { "mxsdev/nvim-dap-vscode-js" },
  -- Web Dev
  {
    'mattn/emmet-vim',
  },
  -- Zettelkasten
  {
    "renerocksai/telekasten.nvim",
    require('telekasten').setup({
      home                        = vim.fn.expand("~/zettelkasten"),
      -- dir names for special notes (absolute path or subdir name)
      dailies                     = home .. '/' .. 'daily',
      weeklies                    = home .. '/' .. 'weekly',
      templates                   = home .. '/' .. 'templates',
      template_new_daily          = home .. '/' .. 'templates/daily.md',
      template_new_weekly         = home .. '/' .. 'templates/weekly.md',
      -- following a link to a non-existing note will create it
      dailies_create_nonexisting  = true,
      weeklies_create_nonexisting = true,
      -- skip telescope prompt for goto_today and goto_thisweek
      journal_auto_open           = false,
    })
  },
  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },
}
