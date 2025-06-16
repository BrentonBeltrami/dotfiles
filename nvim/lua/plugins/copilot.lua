return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  opts = {
    suggestion = { enabled = true },
    panel = { enabled = true },
    filetypes = {
      markdown = false, -- disable in Markdown files
      help = false, -- disable in help files if desired
      ["*"] = true, -- enable in all other file types
    },
  },
  config = function(_, opts)
    require("copilot").setup(opts)
  end,
}
