local add, later = MiniDeps.add, MiniDeps.later

local H = {}

---@param kind string
function H.pick(kind)
  return function()
    local actions = require "CopilotChat.actions"
    local kind_actions = actions[kind .. "_actions"]()

    local items = vim.tbl_map(
      function(name)
        return {
          id = name,
          prompt = kind_actions.actions[name].prompt,
        }
      end,
      vim.tbl_keys(kind_actions.actions)
    )

    vim.ui.select(items, {
      prompt = kind_actions.prompt,
      format_item = function(item) return item.id end,
      preview_item = function(item) return vim.split(item.prompt, "\n", { plain = true }) end,
    }, function(choice)
      if not choice then
        return
      end
      require("CopilotChat").ask(
        kind_actions.actions[choice.id].prompt,
        kind_actions.actions[choice.id]
      )
    end)
  end
end

add "CopilotC-Nvim/CopilotChat.nvim"

later(function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "copilot-chat",
    command = "Markview attach",
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "copilot-chat",
    callback = function()
      vim.opt_local.relativenumber = false
      vim.opt_local.number = false
    end,
  })

  local user = vim.env.USER or "User"
  user = user:sub(1, 1):upper() .. user:sub(2)

  local chat = require "CopilotChat"

  chat.setup {
    auto_insert_mode = false,
    question_header = "  " .. user .. " ",
    answer_header = "  Copilot ",
    model = "gemini-2.0-flash-001",
    prompts = {
      Commit = {
        selection = false,
      },
    },
    mappings = {
      complete = {
        insert = "<c-y>",
      },
      reset = {
        normal = "",
        insert = "",
      },
      accept_diff = {
        normal = "ga",
        insert = "<C-a>",
      },
    },
  }

  vim.keymap.set(
    { "n", "v" },
    "<leader>aa",
    function() require("CopilotChat").toggle() end,
    { desc = "Toggle Copilot Chat" }
  )

  vim.keymap.set(
    { "n", "v" },
    "<leader>ax",
    function() require("CopilotChat").reset() end,
    { desc = "Clear Copilot Chat" }
  )

  vim.keymap.set({ "n", "v" }, "<leader>aq", function()
    local input = vim.fn.input "Quick Chat: "
    if input ~= "" then
      require("CopilotChat").ask(input)
    end
  end, { desc = "Quick Copilot Chat" })

  vim.keymap.set({ "n", "v" }, "<leader>ap", H.pick "prompt", { desc = "CopilotChat Actions" })
end)
