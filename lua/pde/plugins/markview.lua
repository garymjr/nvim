local later = MiniDeps.later

vim.filetype.add {
  extension = { mdx = "markdown.mdx" },
}

later(
  function()
    require("markview").setup {
      preview = {
        icon_provider = "mini",
      },
    }
  end
)
