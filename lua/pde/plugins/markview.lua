local add, later = MiniDeps.add, MiniDeps.later

add("OXY2DEV/markview.nvim")

vim.filetype.add({
  extension = { mdx = "markdown.mdx" },
})

later(function()
  require("markview").setup({
    preview = {
      icon_provider = "mini",
    },
  })
end)
