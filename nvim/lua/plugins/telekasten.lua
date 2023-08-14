-- local home
return {
  "renerocksai/telekasten.nvim",
  config = function()
    require("telekasten").setup({
      home = vim.fn.expand("~/zettelkasten"),
      dailies = "daily",
      weeklies = "weekly",
      templates = "templates",
      template_new_daily = "/templates/daily.md", -- FIXME: templates are not taking for some reason
      template_new_weekly = "templates/weekly.md",
      dailies_create_nonexisting = true,
      weeklies_create_nonexisting = true,
    })
  end,
}
