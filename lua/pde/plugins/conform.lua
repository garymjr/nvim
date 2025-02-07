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
    format_on_save = function(bufnr)
      if vim.b[bufnr].disable_autoformat then
        return
      end

      return {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      }
    end,
  })

  vim.opt.formatexpr = "v:lua.require('conform').formatexpr()"
end)
