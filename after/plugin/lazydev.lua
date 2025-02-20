local later = MiniDeps.later

later(function()
  ---@diagnostic disable-next-line: missing-fields
  require("lazydev").setup {
    library = {
      {
        path = "${3rd}/luv/library",
        words = { "vim%.uv" },
      },
      {
        path = vim.fn.stdpath "data" .. "/site/pack/deps/start/mini.nvim",
        words = { "MiniDeps", "MiniNotify" },
      },
    },
  }
end)
