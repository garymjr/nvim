local add, later = MiniDeps.add, MiniDeps.later

local H = {}

function H.prompt()
	if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
		vim.ui.input({ prompt = "CodeCompanion: " }, function(input)
			if input then
				vim.cmd("'<,'>CodeCompanion " .. input)
			end
		end)
	else
		vim.ui.input({ prompt = "CodeCompanion: " }, function(input)
			if input then
				vim.cmd("CodeCompanion " .. input)
			end
		end)
	end
end

add({ source = "olimorris/codecompanion.nvim", depends = { "nvim-lua/plenary.nvim" } })

later(function()
	require("codecompanion").setup({
		adapters = {
			copilot = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "gemini-2.0-flash-001",
						},
					},
				})
			end,
			gemini = function()
				return require("codecompanion.adapters").extend("gemini", {
					env = {
						api_key = "cmd:security find-generic-password -a aistudio.google.com -s gemini-api-key -w",
					},
					schema = {
						model = {
							default = "gemini-2.0-flash-exp",
						},
					},
				})
			end,
		},
		display = {
			diff = {
				provider = "mini_diff",
			},
		},
		strategies = {
			chat = {
				adapter = "copilot",
				keymaps = {
					close = {
						modes = {
							n = "q",
						},
						index = 4,
						callback = "keymaps.close",
						description = "Close Chat",
					},
					stop = {
						modes = {
							n = "<c-c>",
							i = "<c-c>",
						},
						index = 5,
						callback = "keymaps.stop",
						description = "Stop Request",
					},
				},
			},
			inline = {
				adapter = "copilot",
			},
		},
	})

	vim.keymap.set(
		{ "n", "n" },
		"<leader>aa",
		"<cmd>CodeCompanionChat toggle<cr>",
		{ desc = "Toggle CodeCompanion", silent = true }
	)
	vim.keymap.set(
		{ "n", "v" },
		"<leader>ap",
		"<cmd>CodeCompanionActions<cr>",
		{ desc = "CodeCompanion Actions", silent = true }
	)
	vim.keymap.set({ "n", "v" }, "<leader>aq", H.prompt, { desc = "Inline Chat (CodeCompanion)", silent = true })
end)
