local later = MiniDeps.later

later(function()
  vim.filetype.add {
    extension = { mdx = "markdown.mdx" },
  }
end)

later(function()
  require("render-markdown").setup()
end)

later(function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "copilot-chat" },
    callback = function()
      vim.cmd "RenderMarkdown buf_enable"
    end,
  })
end)
