local M = {}

local H = {}

function M.execute(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }
  return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
end

function H.safe_require(mod)
  vim.schedule(function() pcall(require, mod) end)
end

function M.mini_init() H.safe_require "pde.plugins.mini" end

function M.load_plugins(opts)
  opts = vim.tbl_deep_extend("force", { disabled = {} }, opts or {})

  vim.uv.fs_scandir(vim.fn.stdpath "config" .. "/lua/pde/plugins", function(err, entries)
    if err then
      return
    end

    while true do
      local name, type = vim.uv.fs_scandir_next(entries)
      if not name or not type then
        break
      end
      if type == "file" and string.sub(name, -4) == ".lua" then
        local module_name = string.sub(name, 1, -5)
        if not vim.tbl_contains(opts.disabled, module_name) then
          H.safe_require("pde.plugins." .. module_name)
        end
      end
    end
  end)
end

function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()
  if vim.b[buf].ts_folds == nil then
    if vim.bo[buf].filetype == "" then
      return "0"
    end
    vim.b[buf].ts_folds = pcall(vim.treesitter.get_parser, buf)
  end
  return vim.b[buf].ts_folds and vim.treesitter.foldexpr() or "0"
end

PDE = PDE or {}
PDE.util = M

return M
