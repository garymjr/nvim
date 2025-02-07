local later = MiniDeps.later

later(function()
  require("conform").setup({
    formatters = {
      sqlfluff = {
        args = { "format", "--dialect=ansi", "-" },
      },
    },
    formatters_by_ft = {
      dockerfile = { "hadolint" },
      go = { "goimports", "gofumpt" },
      lua = { "stylua" },
      markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
      ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      mysql = { "sqlfluff" },
      plsql = { "sqlfluff" },
      sql = { "sqlfluff" },
    },
    format_on_save = {
      timeout = 500,
      lsp_format = "fallback",
    },
  })

  vim.opt.formatexpr = "v:lua.require('conform').formatexpr()"
end)
