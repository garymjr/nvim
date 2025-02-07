local add, later = MiniDeps.add, MiniDeps.later

add({
	source = "Saghen/blink.cmp",
	checkout = "v0.11.0",
	monitor = "main",
	depends = { "olimorris/codecompanion.nvim" },
})

later(function()
	require("blink.cmp").setup({
		appearance = {
			use_nvim_cmp_as_default = false,
			nerd_font_variant = "mono",
		},
		completion = {
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
			menu = {
				draw = {
					treesitter = { "lsp" },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
			ghost_text = {
				enabled = false,
			},
		},

		sources = {
			cmdline = {},
			default = { "lsp", "path", "snippets", "buffer", "lazydev", "codecompanion" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
				codecompanion = {
					name = "CodeCompanion",
					module = "codecompanion.providers.completion.blink",
				},
			},
		},
	})
end)
