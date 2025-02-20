local later = MiniDeps.later
local servers = require "microvim.lsp.servers"

local H = {}

function H.ensure_installed(deps)
  local merged_deps = vim.deepcopy(deps)
  for _, server in ipairs(vim.tbl_keys(servers)) do
    table.insert(merged_deps, server)
  end
  return merged_deps
end

later(function()
  require("mason").setup {
    automatic_installation = true,
    ensure_installed = H.ensure_installed {
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
