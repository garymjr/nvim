local path_package = vim.fn.stdpath "data" .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.uv.fs_stat(mini_path) then
  vim.cmd [[echo "Installing `mini.nvim`" | redraw]]
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd "packadd mini.nvim | helptags ALL"
  vim.cmd [[echo "Installed `mini.nvim`" | redraw]]
end

require("mini.deps").setup { path = { package = path_package } }

local add = MiniDeps.add

require "pde.config.options"
require "pde.config.keymaps"
require "pde.config.autocmds"

require "pde.util"

PDE.util.mini_init()

add "github/copilot.vim"

add {
  source = "Saghen/blink.cmp",
  checkout = "v0.12.4",
  monitor = "main",
  depends = { "olimorris/codecompanion.nvim", "kristijanhusak/vim-dadbod-completion" },
}

add {
  source = "olimorris/codecompanion.nvim",
  depends = {
    "nvim-lua/plenary.nvim",
    "OXY2DEV/markview.nvim",
  },
}

add "stevearc/conform.nvim"

add {
  source = "tpope/vim-dadbod",
  depends = { "kristijanhusak/vim-dadbod-ui" },
}

add "mfussenegger/nvim-lint"

add "neovim/nvim-lspconfig"

add {
  source = "williamboman/mason.nvim",
  depends = {
    "williamboman/mason-lspconfig.nvim",
  },
}

add "folke/lazydev.nvim"

add "OXY2DEV/markview.nvim"

add {
  source = "nvim-treesitter/nvim-treesitter",
  hooks = {
    post_checkout = function() vim.cmd "TSUpdate" end,
  },
}

add "nvim-treesitter/nvim-treesitter-context"

add {
  source = "catppuccin/nvim",
  name = "catppuccin",
}

PDE.util.load_plugins()
