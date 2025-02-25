local Path = require "microvim.util.path"
local notify = require "microvim.util.notify"

local servers = require "microvim.lsp.servers"

---@class microvim.lsp
local M = {}

local base_dir = Path(vim.fn.stdpath "config" .. "/lsp")

function M.setup()
  if not base_dir:exists() then
    notify.error "LSP directory does not exist"
  end

  local capabilities = vim.tbl_deep_extend("force", {
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  }, vim.lsp.protocol.make_client_capabilities(), require("blink.cmp").get_lsp_capabilities())

  for server, server_opts in pairs(servers) do
    local path = base_dir:join(server .. ".lua")
    if not path:exists() and server ~= "*" then
      notify.error("LSP config does not exist: " .. path:get())
      return
    end

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
