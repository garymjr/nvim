local function augroup(name)
	return vim.api.nvim_create_augroup("gwm_" .. name, { clear = true })
end

local map = vim.keymap.set

local ignored_filetypes = {
	"copilot-chat",
	"codecompanion",
}

local function is_ignored(buffer)
	local ft = vim.bo[buffer].filetype
	if vim.list_contains(ignored_filetypes, ft) then
		return true
	end
	return false
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"checkhealth",
		"dbout",
		"help",
		"lspinfo",
		"notify",
		"qf",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "q", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})

-- wrap in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap"),
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
	end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = augroup("json_conceal"),
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Setup LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup("lsp_keymaps"),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and not is_ignored(args.buf) then
			map("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info", buffer = args.buf })
			map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "Goto Declaration", buffer = args.buf })
			map(
				"n",
				"<leader>gK",
				"<cmd>lua vim.lsp.buf.signature_help()<cr>",
				{ desc = "Signature Help", buffer = args.buf }
			)
			map(
				"i",
				"<c-k>",
				"<cmd>lua vim.lsp.buf.signature_help()<cr>",
				{ desc = "Signature Help", buffer = args.buf }
			)
			map(
				"n",
				"<leader>ca",
				"<cmd>lua vim.lsp.buf.code_action()<cr>",
				{ desc = "Code Action", buffer = args.buf }
			)
			map("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename", buffer = args.buf })

			map(
				"n",
				"<leader>ss",
				"<cmd>Telescope lsp_document_symbols<cr>",
				{ desc = "Goto Symbol", buffer = args.buf }
			)
			map(
				"n",
				"<leader>sS",
				"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
				{ desc = "Goto Symbol (Workspace)", buffer = args.buf }
			)
			map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Goto Definition", buffer = args.buf })
			map("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "References", buffer = args.buf })
			map(
				"n",
				"gI",
				"<cmd>Telescope lsp_implementations<cr>",
				{ desc = "Goto Implementation", buffer = args.buf }
			)
			map(
				"n",
				"gy",
				"<cmd>Telescope lsp_type_definitions<cr>",
				{ desc = "Goto Type Definition", buffer = args.buf }
			)
		end
	end,
})
