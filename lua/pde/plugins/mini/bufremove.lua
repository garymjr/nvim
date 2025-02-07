require("mini.bufremove").setup()

vim.keymap.set("n", "<leader>bd", MiniBufremove.wipeout, { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>bD", function()
	MiniBufremove.wipeout(0, true)
end, { desc = "Delete Buffer (force)" })
