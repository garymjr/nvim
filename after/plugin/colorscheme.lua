local now = MiniDeps.now

now(function()
  require("poimandres").setup()
end)

now(function()
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "poimandres",
    callback = function()
      vim.api.nvim_set_hl(0, "LspReferenceText", { fg = "#e4f0fb", bg = "#506477" })
    end,
  })

  vim.cmd.colorscheme "poimandres"
end)
