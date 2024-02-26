local add = MiniDeps.add
local later = MiniDeps.later

add({
  source = "nvim-treesitter/nvim-treesitter",
  hooks = { post_checkout = function() vim.cmd("TSUpdate") end }
})

later(function()
  require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "bash",
      "diff",
      "go",
      "gomod",
      "gowork",
      "gosum",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "json5",
      "jsonc",
      "lua",
      "markdown",
      "markdown_inline",
      "query",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vimdoc",
      "yaml",
    },
  })
end)
