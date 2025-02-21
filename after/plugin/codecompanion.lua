local later = MiniDeps.later

local H = {
  notifications = {},
}

local function prompt()
  if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
    vim.ui.input({ prompt = "CodeCompanion: " }, function(input)
      if input then
        vim.cmd("'<,'>CodeCompanion " .. input)
      end
    end)
  else
    vim.ui.input({ prompt = "CodeCompanion: " }, function(input)
      if input then
        vim.cmd("CodeCompanion " .. input)
      end
    end)
  end
end

function H:init()
  local group = vim.api.nvim_create_augroup("microvim_codecompanion_hooks", { clear = true })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(request)
      local notification = H:create_progress_notification(request)
      H:store_progress_notification(request.data.id, notification)
    end,
  })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(request)
      local notification = H:pop_progress_notification(request.data.id)
      if notification then
        H:report_exit_status(notification, request)
      end
    end,
  })
end

function H:store_progress_notification(id, notification)
  H.notifications[id] = notification
end

function H:pop_progress_notification(id)
  local notification = H.notifications[id]
  H.notifications[id] = nil
  return notification
end

function H:create_progress_notification(request)
  return MiniNotify.add(" Requesting assistance (" .. request.data.strategy .. ")", "INFO")
end

function H:llm_role_title(adapter)
  local parts = {}
  table.insert(parts, adapter.formatted_name)
  if adapter.model and adapter.model ~= "" then
    table.insert(parts, "(" .. adapter.model .. ")")
  end
  return table.concat(parts, " ")
end

function H:report_exit_status(notification, request)
  if request.data.status == "success" then
    MiniNotify.update(notification, { msg = "󰌵 Success" })
    vim.defer_fn(function()
      MiniNotify.remove(notification)
    end, 1000)
  elseif request.data.status == "error" then
    MiniNotify.update(notification, { msg = " Error", level = "ERROR" })
    vim.defer_fn(function()
      MiniNotify.remove(notification)
    end, 5000)
  else
    MiniNotify.update(notification, { msg = "󰜺 Cancelled", level = "WARN" })
    vim.defer_fn(function()
      MiniNotify.remove(notification)
    end, 1000)
  end
end

later(function()
  require("codecompanion").setup {
    adapters = {
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = {
              default = "gemini-2.0-flash-001",
            },
          },
        })
      end,
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = "cmd:security find-generic-password -a aistudio.google.com -s gemini-api-key -w",
          },
          schema = {
            model = {
              default = "gemini-2.0-flash-exp",
            },
          },
        })
      end,
    },
    display = {
      diff = {
        provider = "mini_diff",
      },
    },
    prompt_library = {
      ["Generate a Commit Message"] = {
        strategy = "chat",
        description = "Generate a commit message",
        opts = {
          index = 10,
          is_default = true,
          is_slash_cmd = true,
          short_name = "commit",
          auto_submit = true,
        },
        prompts = {
          {
            role = "user",
            content = function()
              return string.format(
                [[Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.
```diff
%s
```]],
                vim.fn.system "git diff --no-ext-diff --staged"
              )
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
    },
    strategies = {
      chat = {
        adapter = "copilot",
        keymaps = {
          close = {
            modes = {
              n = "q",
            },
            index = 4,
            callback = "keymaps.close",
            description = "Close Chat",
          },
          stop = {
            modes = {
              n = "<c-c>",
              i = "<c-c>",
            },
            index = 5,
            callback = "keymaps.stop",
            description = "Stop Request",
          },
        },
      },
      inline = {
        adapter = "copilot",
      },
    },
  }
end)

later(function()
  vim.keymap.set(
    { "n", "v" },
    "<leader>aa",
    "<cmd>CodeCompanionChat toggle<cr>",
    { desc = "Toggle CodeCompanion", silent = true }
  )
  vim.keymap.set(
    { "n", "v" },
    "<leader>ap",
    "<cmd>CodeCompanionActions<cr>",
    { desc = "CodeCompanion Actions", silent = true }
  )
  vim.keymap.set(
    { "n", "v" },
    "<leader>aq",
    prompt,
    { desc = "Inline Chat (CodeCompanion)", silent = true }
  )
end)

later(function()
  H:init()
end)
