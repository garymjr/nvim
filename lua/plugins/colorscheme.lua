local add = MiniDeps.add
local now = MiniDeps.now

add("ribru17/bamboo.nvim")

now(function()
  require("bamboo").setup({
    code_style = {
      conditionals = {},
      namespaces = {},
      parameters = {},
    },
  })

  vim.cmd.colorscheme("bamboo")
end)
