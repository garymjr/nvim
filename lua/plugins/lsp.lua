local add = MiniDeps.add
local later = MiniDeps.later

add("williamboman/mason.nvim")
add("williamboman/mason-lspconfig.nvim")
add("neovim/nvim-lspconfig")
add("folke/neodev.nvim")

later(require("mason").setup)
later(require("mason-lspconfig").setup)

later(function()
  vim.diagnostic.config({
    signs = {
      priorty = 9999,
      severity = {
        min = vim.diagnostic.severity.WARN,
        max = vim.diagnostic.severity.ERROR,
      },
    },
    virtual_text = {
      severity = {
        min = vim.diagnostic.severity.WARN,
        max = vim.diagnostic.severity.ERROR,
      },
    },
    update_in_insert = false,
  })
end)

later(require("neodev").setup)

later(function()
  local luals_root = vim.fn.stdpath('data') .. '/mason'
  local luals_binary = luals_root .. "/bin/lua-language-server"
  local lspconfig = require("lspconfig")

  lspconfig.lua_ls.setup({
    handlers = {
      ["textDocument/definition"] = function(err, result, ctx, config)
        if type(result) == "table" then result = { result[1] } end
        vim.lsp.handlers["textDocument/definition"](err, result, ctx, config)
      end,
    },
    cmd = { luals_binary },
    on_attach = function(client)
      client.server_capabilities.completionProvider.triggerCharacters = { '.', ':' }
    end,
    root_dir = function(fname) return lspconfig.util.root_pattern(".git")(fname) or lspconfig.util.path.dirname(fname) end,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = vim.split(package.path, ";"),
        },
        diagnostics = {
          globals = { "vim" },
          disable = { "need-check-nil" },
          workspaceDelay = -1,
        },
        workspace = {
          ignoreSubmodules = true,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })
end)

later(function()
  require("lspconfig").gopls.setup({
    settings = {
      gopls = {
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        analyses = {
          fieldalignment = true,
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        semanticTokens = true,
      },
    },
  })
end)

later(function()
  require("lspconfig").tsserver.setup({
    settings = {
      completions = {
        completeFunctionCalls = true,
      },
    },
  })
end)
