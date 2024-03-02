local add = MiniDeps.add

add("stevearc/oil.nvim")
add("stevearc/conform.nvim")
add("stevearc/dressing.nvim")

add("tpope/vim-dadbod")

add("sindrets/diffview.nvim")
add("lewis6991/gitsigns.nvim")

add("numToStr/Navigator.nvim")

add({
  source = "nvim-treesitter/nvim-treesitter",
  hooks = { post_checkout = function() vim.cmd("TSUpdate") end }
})

add("williamboman/mason.nvim")
add("williamboman/mason-lspconfig.nvim")
add("neovim/nvim-lspconfig")
add("folke/neodev.nvim")

local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"
local function scan_plugins(dir)
  if not dir then
    dir = plugin_dir
  end

  local handle = vim.uv.fs_scandir(dir)
  while handle do
    local name, t = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end

    if t == "directory" then
      scan_plugins(dir .. "/" .. name)
    end

    if t == "file" and name:match("%.lua") then
      local mod = name:gsub("%.lua", "")
      mod = mod:gsub(plugin_dir .. "/", "")

      if dir ~= plugin_dir then
        local prefix = dir:gsub(plugin_dir .. "/", "")
        mod = prefix .. "." .. mod
      end

      mod = mod:gsub(".init", "")

      if mod ~= "init" then
        require("plugins." .. mod)
      end
    end
  end
end

scan_plugins(plugin_dir)
