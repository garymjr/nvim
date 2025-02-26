local H = {}

function H.on_attach(client, bufnr)
  local ignored_filetypes = { "codecompanion", "copilot-chat" }
  if vim.tbl_contains(ignored_filetypes, vim.bo[bufnr].filetype) or not client then
    return
  end

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
end

return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    lazy = false,
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" } },
    },
    build = ":MasonUpdate",
    opts = {
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
      servers = {
        ["*"] = {
          on_attach = H.on_attach,
        },
        lexical = {
          cmd = { vim.fn.stdpath "data" .. "/mason/bin/lexical" },
          filetypes = { "elixir", "eelixir", "heex", "surface" },
          root_markers = { "mix.exs" },
          single_file_support = true,
        },
        lua_ls = {
          cmd = { "lua-language-server" },
          filetypes = { "lua" },
          log_level = vim.lsp.protocol.MessageType.Warning,
          root_markers = {
            ".luarc.json",
            ".luarc.jsonc",
            ".luacheckrc",
            ".stylua.toml",
            "stylua.toml",
            "selene.toml",
            "selene.yml",
            ".git",
          },
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
          single_file_support = true,
        },
        gopls = {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_markers = { "go.work", "go.mod", ".git" },
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
          single_file_support = true,
        },
        jsonls = {
          cmd = { "vscode-json-language-server", "--stdio" },
          filetypes = { "json", "jsonc" },
          init_options = {
            provideFormatter = true,
          },
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          root_markers = { ".git" },
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
          single_file_support = true,
        },
        tailwindcss = {
          cmd = { "tailwindcss-language-server", "--stdio" },
          -- filetypes copied and adjusted from tailwindcss-intellisense
          filetypes = {
            -- html
            "aspnetcorerazor",
            "astro",
            "astro-markdown",
            "blade",
            "clojure",
            "django-html",
            "htmldjango",
            "edge",
            "eelixir", -- vim ft
            "elixir",
            "ejs",
            "erb",
            "eruby", -- vim ft
            "gohtml",
            "gohtmltmpl",
            "haml",
            "handlebars",
            "hbs",
            "html",
            "htmlangular",
            "html-eex",
            "heex",
            "jade",
            "leaf",
            "liquid",
            "markdown",
            "mdx",
            "mustache",
            "njk",
            "nunjucks",
            "php",
            "razor",
            "slim",
            "twig",
            -- css
            "css",
            "less",
            "postcss",
            "sass",
            "scss",
            "stylus",
            "sugarss",
            -- js
            "javascript",
            "javascriptreact",
            "reason",
            "rescript",
            "typescript",
            "typescriptreact",
            -- mixed
            "vue",
            "svelte",
            "templ",
          },
          on_new_config = function(new_config)
            if not new_config.settings then
              new_config.settings = {}
            end
            if not new_config.settings.editor then
              new_config.settings.editor = {}
            end
            if not new_config.settings.editor.tabSize then
              -- set tab size for hover
              new_config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
            end
          end,
          settings = {
            tailwindCSS = {
              validate = true,
              lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidScreen = "error",
                invalidVariant = "error",
                invalidConfigPath = "error",
                invalidTailwindDirective = "error",
                recommendedVariantOrder = "warning",
              },
              classAttributes = {
                "class",
                "className",
                "class:list",
                "classList",
                "ngClass",
              },
              includeLanguages = {
                elixir = "html-eex",
                eelixir = "html-eex",
                eruby = "erb",
                heex = "html-eex",
                templ = "html",
                htmlangular = "html",
              },
            },
          },
          root_markers = {
            "tailwind.config.js",
            "tailwind.config.cjs",
            "tailwind.config.mjs",
            "tailwind.config.ts",
            "postcss.config.js",
            "postcss.config.cjs",
            "postcss.config.mjs",
            "postcss.config.ts",
            "package.json",
            ".git",
          },
        },
        vtsls = {
          cmd = { "vtsls", "--stdio" },
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
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
          single_file_support = true,
        },
      },
    },
    config = function(_, opts)
      require("mason").setup()
      local mr = require "mason-registry"
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger {
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          }
        end, 100)
      end)

      vim.diagnostic.config(opts.diagnostics)

      for server, server_opts in pairs(opts.servers) do
        server_opts.capabilities = vim.tbl_deep_extend(
          "force",
          {},
          vim.lsp.protocol.make_client_capabilities(),
          require("blink.cmp").get_lsp_capabilities(),
          opts.capabilities or {},
          server_opts.capabilities or {}
        )

        vim.lsp.config(server, server_opts)

        if server ~= "*" then
          vim.lsp.enable(server)
        end
      end
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    priority = 1000,
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "shfmt",
      },
    },
  },
}
