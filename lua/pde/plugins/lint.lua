local later = MiniDeps.later

later(
  function()
    require("lint").linters_by_ft = {
      elixir = { "credo" },
      markdown = { "markdownlint-cli2" },
      mysql = { "sqlfluff" },
      plsql = { "sqlfluff" },
      sql = { "sqlfluff" },
    }
  end
)

later(function()
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function() require("lint").try_lint() end,
  })
end)
