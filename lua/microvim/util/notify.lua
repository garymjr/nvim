---@class microvim.util.notify
---@field info fun(msg: string)
---@field warn fun(msg: string)
---@field error fun(msg: string)
local M = {}

setmetatable(M, {
  __index = function(_, k)
    return function(...)
      local id = MiniNotify.add(..., string.upper(k))
      vim.defer_fn(function()
        MiniNotify.remove(id)
      end, 2000)
    end
  end,
})

return M
