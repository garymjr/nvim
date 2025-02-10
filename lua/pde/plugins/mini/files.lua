require("mini.files").setup()

vim.keymap.set("n", "-", function()
	MiniFiles.open(vim.fn.expand("%"))
end, { silent = true })
