return {
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    opts = {
      linters = {},
      linters_by_ft = {
        elixir = { "credo" },
        markdown = { "markdownlint-cli2" },
        mysql = { "sqlfluff" },
        plsql = { "sqlfluff" },
        sql = { "sqlfluff" },
      },
    },
    config = function(_, opts)
      require("lint").linters = opts.linters
      require("lint").linters_by_ft = opts.linters_by_ft

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
