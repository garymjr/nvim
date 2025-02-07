vim.filetype.add({
	extension = {
		ex = "elixir",
	},
})

vim.treesitter.language.register("markdown", "livebook")

return {}
