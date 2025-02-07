require("mini.pick").setup()

vim.keymap.set("n", "<leader>fb", function()
	MiniPick.builtin.buffers({ include_current = false })
end, { silent = true })

vim.keymap.set("n", "<leader>fc", function()
	MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath("config") } })
end, { silent = true })

vim.keymap.set("n", "<leader>ff", function()
	MiniPick.builtin.files()
end, { silent = true })

vim.keymap.set("n", "<leader>fp", function()
	MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath("data") .. "/site/pack/deps" } })
end, { silent = true })

vim.keymap.set("n", "<leader>fr", function()
	MiniExtra.pickers.oldfiles({ current_dir = true })
end, { silent = true })

vim.keymap.set("n", "<leader>fR", function()
	MiniExtra.pickers.oldfiles()
end, { silent = true })

vim.keymap.set("n", "<leader>sd", function()
	MiniExtra.pickers.diagnostic({ scope = "current" })
end, { silent = true })

vim.keymap.set("n", "<leader>sD", function()
	MiniExtra.pickers.diagnostic()
end, { silent = true })

vim.keymap.set("n", "<leader>sh", function()
	MiniPick.builtin.help()
end, { silent = true })

vim.keymap.set("n", "<leader>sg", function()
	MiniPick.builtin.grep_live()
end, { silent = true })

vim.keymap.set("n", "<leader>sR", function()
	MiniPick.builtin.resume()
end, { silent = true })

vim.keymap.set("n", "<leader>ss", function()
	MiniExtra.pickers.lsp({ scope = "document_symbol" })
end, { silent = true })

vim.keymap.set("n", "<leader>sS", function()
	MiniExtra.pickers.lsp({ scope = "workspace_symbol" })
end, { silent = true })
