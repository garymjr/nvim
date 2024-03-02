MiniDeps.later(function()
  require("diffview").setup({
    view = {
      gq = "<cmd>DiffViewClose<cr>",
    },
  })
  vim.keymap.set("n", "<leader>gs", "<cmd>DiffviewOpen<cr>", { silent = true })
end)
