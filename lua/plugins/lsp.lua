return {
	"nvim-lspconfig",
	opts = {
		document_highlight = {
			enabled = false,
		},
		inlay_hints = {
			enabled = false,
		},
		servers = {
			elixirls = {
				settings = {
					elixirLS = {
						dialyzerEnabled = false,
					},
				},
			},
		},
	},
}
