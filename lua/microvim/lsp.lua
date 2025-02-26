local notify = require "microvim.util.notify"

local servers = require "microvim.lsp.servers"

---@class microvim.lsp
local M = {}

function M.setup()
  local capabilities = vim.tbl_deep_extend("force", {
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  }, vim.lsp.protocol.make_client_capabilities(), require("blink.cmp").get_lsp_capabilities())

  for server, server_opts in pairs(servers) do
    local config = vim.tbl_deep_extend("force", {
      capabilities = capabilities,
    }, server_opts or {})

    vim.lsp.config(server, config)
  end

  local active_servers = vim.tbl_filter(function(value)
    return value ~= "*"
  end, vim.tbl_keys(servers))
  vim.lsp.enable(active_servers)
end

return M
