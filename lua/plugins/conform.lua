local add = MiniDeps.add
local later = MiniDeps.later

add("stevearc/conform.nvim")

later(function()
  require("conform").setup({
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  })
end)
