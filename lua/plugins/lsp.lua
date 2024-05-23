return {
	{
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
	},
	{
		"j-hui/fidget.nvim",
    event = "VeryLazy",
    dependencies = {"nvim-lspconfig"},
		opts = {},
	},
}
