-- local progress = require("fidget.progress")

local M = {}

function M:init()
  local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(request)
      local notification = M:create_progress_notification(request)
      M:store_progress_notification(request.data.id, notification)
    end,
  })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(request)
      local notification = M:pop_progress_notification(request.data.id)
      if notification then
        M:report_exit_status(notification, request)
      end
    end,
  })
end

M.notifications = {}

function M:store_progress_notification(id, notification) M.notifications[id] = notification end

function M:pop_progress_notification(id)
  local notification = M.notifications[id]
  M.notifications[id] = nil
  return notification
end

function M:create_progress_notification(request)
  return MiniNotify.add(" Requesting assistance (" .. request.data.strategy .. ")", "INFO")
end

function M:llm_role_title(adapter)
  local parts = {}
  table.insert(parts, adapter.formatted_name)
  if adapter.model and adapter.model ~= "" then
    table.insert(parts, "(" .. adapter.model .. ")")
  end
  return table.concat(parts, " ")
end

function M:report_exit_status(notification, request)
  if request.data.status == "success" then
    MiniNotify.update(notification, { msg = "󰌵 Success" })
    vim.defer_fn(function() MiniNotify.remove(notification) end, 1000)
  elseif request.data.status == "error" then
    MiniNotify.update(notification, { msg = " Error", level = "ERROR" })
    vim.defer_fn(function() MiniNotify.remove(notification) end, 5000)
  else
    MiniNotify.update(notification, { msg = "󰜺 Cancelled", level = "WARN" })
    vim.defer_fn(function() MiniNotify.remove(notification) end, 1000)
  end
end

return M
