vim.g.autoformat = false

local opt = vim.opt

opt.cursorline = false
opt.timeoutlen = 300

vim.filetype.add({
	extension = {
		mdx = "mdx",
	},
})

vim.treesitter.language.register("markdown", "mdx")
