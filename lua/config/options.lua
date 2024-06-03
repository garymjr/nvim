vim.g.autoformat = false
vim.g.trouble_lualine = false

local opt = vim.opt

opt.cursorline = false
opt.swapfile = false
opt.timeoutlen = 300

vim.filetype.add({
	extension = {
		mdx = "mdx",
	},
})

vim.treesitter.language.register("markdown", "mdx")
