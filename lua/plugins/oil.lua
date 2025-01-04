return {
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<cr>", silent = true },
    },
    opts = {
      keymaps = {
        ["q"] = { "actions.close", mode = "n" },
      },
    },
  }
}
