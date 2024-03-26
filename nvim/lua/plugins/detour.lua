return {
  "carbon-steel/detour.nvim",
  config = function()
    vim.keymap.set("n", "<c-w><enter>", ":Detour<cr>")
  end,
}
