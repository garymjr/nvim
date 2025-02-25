local now = MiniDeps.now
local servers = require "microvim.lsp.servers"

local H = {}

function H.ensure_installed(deps)
  local merged_deps = vim.deepcopy(deps)
  for _, server in ipairs(vim.tbl_keys(servers)) do
    if server ~= "*" then
      table.insert(merged_deps, server)
    end
  end
  return merged_deps
end

now(function()
  require("mason").setup()
end)

now(function()
  require("mason-tool-installer").setup {
    ensure_installed = H.ensure_installed {
      "gofumpt",
      "goimports",
      "hadolint",
      "markdownlint-cli2",
      "markdown-toc",
      "prettier",
      "sqlfluff",
    },
    run_on_start = true,
  }
end)
