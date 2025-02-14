local later = MiniDeps.later

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
		prompt_library = {
			["Generate a Commit Message"] = {
				strategy = "chat",
				description = "Generate a commit message",
				opts = {
					index = 10,
					is_default = true,
					is_slash_cmd = true,
					short_name = "commit",
					auto_submit = true,
				},
				prompts = {
					{
						role = "user",
						content = function()
							return string.format(
								[[Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.
```diff
%s
```]],
								vim.fn.system("git diff --no-ext-diff --staged")
							)
						end,
						opts = {
							contains_code = true,
						},
					},
				},
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
		{ "n", "v" },
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

	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("pde_codecompanion", { clear = true }),
		pattern = "codecompanion",
		command = "Markview attach",
	})
end)

later(function()
	require("pde.plugins.codecompanion.spinner"):init()
end)
