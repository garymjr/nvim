local Path = require "microvim.util.path"
local notify = require "microvim.util.notify"

---@class microvim.lsp
local M = {}

local base_dir = Path(vim.fn.stdpath "config" .. "/lsp")

---@param name string
---@param opts? table
function M.setup(name, opts)
  if not base_dir:exists() then
    notify.error "LSP directory does not exist"
  end

  local path = base_dir:join(name .. ".lua")
  if not path:exists() then
    notify.error("LSP config does not exist: " .. path:get())
    return
  end
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end

return M
