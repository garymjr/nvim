local now, later = MiniDeps.now, MiniDeps.later
local servers = require "microvim.lsp.servers"

local function ensure_installed(deps)
  local merged_deps = vim.deepcopy(deps)
  for _, server in ipairs(vim.tbl_keys(servers)) do
    table.insert(merged_deps, server)
  end
  return merged_deps
end

now(function()
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
end)

local capabilities = vim.tbl_deep_extend("force", {
  workspace = {
    fileOperations = {
      didRename = true,
      willRename = true,
    },
  },
}, vim.lsp.protocol.make_client_capabilities(), require("blink.cmp").get_lsp_capabilities())

now(function()
  for _, server in ipairs(vim.tbl_keys(servers)) do
    local config = vim.tbl_deep_extend("force", {
      capabilities = capabilities,
    }, servers[server] or {})
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
  end
end)

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
    ensure_installed = ensure_installed {
      "gofumpt",
      "goimports",
      "hadolint",
      "markdownlint-cli2",
      "markdown-toc",
      "prettier",
      "sqlfluff",
    },
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
