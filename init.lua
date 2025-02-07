local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.uv.fs_stat(mini_path) then
  vim.cmd([[echo "Installing `mini.nvim`" | redraw]])
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd([[echo "Installed `mini.nvim`" | redraw]])
end

require("mini.deps").setup({ path = { package = path_package } })

require("pde.config.options")
require("pde.config.keymaps")
require("pde.config.autocmds")

require("pde.util")

require("pde.plugins.mini")
require("pde.plugins.copilot")
require("pde.plugins.blink")

require("pde.plugins.treesitter")
require("pde.plugins.lspconfig")

require("pde.plugins.conform")
require("pde.plugins.lint")

require("pde.plugins.codecompanion")
