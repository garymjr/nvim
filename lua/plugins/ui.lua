return {
	{ "bufferline.nvim", enabled = false },
  { "noice.nvim", enabled = false },
  {
    "dashboard-nvim",
    opts = function(_, opts)
      opts.config.header = vim.split(string.rep("\n", 15), "\n")
    end,
  }
}
