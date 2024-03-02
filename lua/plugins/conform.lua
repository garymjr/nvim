MiniDeps.later(function()
  require("conform").setup({
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  })
end)
