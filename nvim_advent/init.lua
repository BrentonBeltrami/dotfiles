print("Advent Of NeoVim!")

require("config.lazy")

vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"

-- Runs whole file
vim.keymap.set('n', '<Space><Space>x', '<cmd>source %<CR>')
-- Runs only on current line
vim.keymap.set('n','<Space>x',':.lua<CR>')
vim.keymap.set('v','<Space>x',':lua<CR>')

vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight text on yank',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', {clear = true}),
	callback = function()
		vim.highlight.on_yank()
	end
})
