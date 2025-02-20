---@type table<string, vim.lsp.Config>
local M = {
  elixirls = {
    cmd = { vim.fn.stdpath "data" .. "/mason/bin/elixir-ls" },
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "<leader>cp", function()
        ---@diagnostic disable-next-line: missing-parameter
        local params = vim.lsp.util.make_position_params()
        PDE.util.execute {
          command = "manipulatePipes:serverid",
          arguments = {
            "toPipe",
            params.textDocument.uri,
            params.position.line,
            params.position.character,
          },
        }
      end, { desc = "To Pipe", buffer = bufnr })

      vim.keymap.set("n", "<leader>cP", function()
        ---@diagnostic disable-next-line: missing-parameter
        local params = vim.lsp.util.make_position_params()
        PDE.util.execute {
          command = "manipulatePipes:serverid",
          arguments = {
            "fromPipe",
            params.textDocument.uri,
            params.position.line,
            params.position.character,
          },
        }
      end, { desc = "From Pipe", buffer = bufnr })
    end,
  },
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
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
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        semanticTokens = true,
      },
    },
  },
  jsonls = {
    on_new_config = function(new_config)
      MiniDeps.add "b0o/SchemaStore.nvim"
      new_config.settings.json.schemas = new_config.settings.json.schemas or {}
      vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
    end,
    settings = {
      json = {
        format = {
          enable = true,
        },
        validate = { enable = true },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
        },
        completion = {
          callSnippet = "Replace",
        },
        doc = {
          privateName = { "^_" },
        },
      },
    },
  },
  tailwindcss = {
    settings = {
      tailwindCSS = {
        includeLanguages = {
          elixir = "html-eex",
          eelixir = "html-eex",
          heex = "html-eex",
        },
      },
    },
  },
  vtsls = {
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "gD", function()
        ---@diagnostic disable-next-line: missing-parameter
        local params = vim.lsp.util.make_position_params()
        PDE.util.execute {
          command = "typescript.goToSourceDefinition",
          arguments = { params.textDocument.uri, params.position },
          open = true,
        }
      end, { desc = "Goto Source Definition", buffer = bufnr })

      vim.keymap.set("n", "gR", function()
        PDE.util.execute {
          command = "typescript.findAllFileReferences",
          arguments = { vim.uri_from_bufnr(0) },
          open = true,
        }
      end, { desc = "File References", buffer = bufnr })
    end,
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          maxInlayHintLength = 30,
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
      javascript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = {
          completeFunctionCalls = true,
        },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = {
          completeFunctionCalls = true,
        },
      },
    },
  },
}

return M
