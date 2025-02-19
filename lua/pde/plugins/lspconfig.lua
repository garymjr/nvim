local now, later = MiniDeps.now, MiniDeps.later

now(
  function()
    vim.diagnostic.config {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = " ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    }
  end
)

local capabilities = vim.tbl_deep_extend("force", {
  workspace = {
    fileOperations = {
      didRename = true,
      willRename = true,
    },
  },
}, vim.lsp.protocol.make_client_capabilities(), require("blink.cmp").get_lsp_capabilities())

local function setup(server)
  local has_opts, opts = pcall(require, "pde.config.lsp." .. server)
  local server_opts = vim.tbl_deep_extend(
    "force",
    { capabilities = vim.deepcopy(capabilities) },
    has_opts and opts or {}
  )
  require("lspconfig")[server].setup(server_opts)
end

later(function()
  ---@diagnostic disable-next-line: missing-fields
  require("lazydev").setup {
    library = {
      {
        path = "${3rd}/luv/library",
        words = { "vim%.uv" },
      },
      {
        path = vim.fn.stdpath "data" .. "/site/pack/deps/start/mini.nvim",
        words = { "MiniDeps", "MiniNotify" },
      },
    },
  }
end)

-- later(function()
--   require("fidget").setup({})
-- end)

later(function()
  require("mason").setup {
    automatic_installation = true,
    ensure_installed = {
      "gofumpt",
      "goimports",
      "hadolint",
      "markdownlint-cli2",
      "markdown-toc",
      "prettier",
      "sqlfluff",
    },
  }
  ---@diagnostic disable-next-line: missing-fields
  require("mason-lspconfig").setup {
    automatic_installation = true,
    ensure_installed = {
      "docker_compose_language_service",
      "dockerls",
      "elixirls",
      "gopls",
      "jsonls",
      "lua_ls",
      "marksman",
      "tailwindcss",
      "vtsls",
    },
    handlers = { setup },
  }
end)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("pde_lsp_attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    local ignored_filetypes = { "codecompanion" }
    if vim.tbl_contains(ignored_filetypes, vim.bo[args.buf].filetype) or not client then
      return
    end

    vim.keymap.set(
      "n",
      "gd",
      vim.lsp.buf.definition,
      { buffer = args.buf, desc = "Go to Definition" }
    )
  end,
})
