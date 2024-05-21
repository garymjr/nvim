return {
	{
		"nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = {
				"bash",
				"diff",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
			}

			opts.textobjects.move = {
				goto_next_start = { ["]f"] = "@function.outer" },
				goto_next_end = { ["]F"] = "@function.outer" },
				goto_previous_start = { ["[f"] = "@function.outer" },
				goto_previous_end = { ["[F"] = "@function.outer" },
			}
		end,
	},
}
