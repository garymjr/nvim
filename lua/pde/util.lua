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
  vim.schedule(function()
    pcall(require, mod)
  end)
end

function M.mini_init()
  H.safe_require("pde.plugins.mini")
end

function M.load_plugins()
  vim.uv.fs_scandir(vim.fn.stdpath("config") .. "/lua/pde/plugins", function(err, entries)
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
        H.safe_require("pde.plugins." .. module_name)
      end
    end
  end)
end

PDE = PDE or {}
PDE.util = M

return M
