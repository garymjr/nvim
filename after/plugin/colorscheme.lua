local now = MiniDeps.now

now(function()
  require("bamboo").setup {
    style = "vulgaris",
    code_style = {
      conditionals = { italic = false },
      namespaces = { italic = false },
    },
  }

  vim.cmd.colorscheme "bamboo"
end)
