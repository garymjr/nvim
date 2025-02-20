local win_config = function()
  local height = math.floor(0.618 * vim.o.lines)
  local width = math.floor(0.618 * vim.o.columns)
  return {
    anchor = "NW",
    height = height,
    width = width,
    row = math.floor(0.5 * (vim.o.lines - height)),
    col = math.floor(0.5 * (vim.o.columns - width)),
  }
end

require("mini.pick").setup {
  mappings = {
    scroll_down = "<C-j>",
    scroll_left = "<C-h>",
    scroll_right = "<C-l>",
    scroll_up = "<C-k>",
  },
  window = { config = win_config },
}

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
  local height = math.floor(0.218 * vim.o.lines)
  local width = math.floor(0.5 * vim.o.columns)
  local row = math.floor(0.5 * (vim.o.lines - height))
  local col = math.floor(0.5 * (vim.o.columns - width))

  MiniPick.ui_select(items, opts, on_choice, {
    window = {
      config = {
        anchor = "NW",
        height = height,
        width = width,
        row = row,
        col = col,
      },
    },
  })
end

vim.keymap.set("n", "<leader>fb", function()
  MiniPick.builtin.buffers { include_current = false }
end, { silent = true, desc = "Find buffers" })

vim.keymap.set("n", "<leader>fc", function()
  MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath "config" } })
end, { silent = true, desc = "Find config" })

vim.keymap.set("n", "<leader>ff", function()
  MiniPick.builtin.files()
end, { silent = true, desc = "Find files" })

vim.keymap.set("n", "<leader>fp", function()
  MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath "data" .. "/site/pack/deps" } })
end, { silent = true, desc = "Find plugins" })

vim.keymap.set("n", "<leader>fr", function()
  MiniExtra.pickers.oldfiles { current_dir = true }
end, { silent = true, desc = "Find recent files (cwd)" })

vim.keymap.set("n", "<leader>fR", function()
  MiniExtra.pickers.oldfiles()
end, { silent = true, desc = "Find recent files" })

vim.keymap.set("n", "<leader>sd", function()
  MiniExtra.pickers.diagnostic { scope = "current" }
end, { silent = true, desc = "Search diagnostics" })

vim.keymap.set("n", "<leader>sD", function()
  MiniExtra.pickers.diagnostic()
end, { silent = true, desc = "Search all diagnostics" })

vim.keymap.set("n", "<leader>sh", function()
  MiniPick.builtin.help()
end, { silent = true, desc = "Search help" })

vim.keymap.set("n", "<leader>sg", function()
  MiniPick.builtin.grep_live()
end, { silent = true, desc = "Search grep" })

vim.keymap.set("n", "<leader>sR", function()
  MiniPick.builtin.resume()
end, { silent = true, desc = "Search resume" })

vim.keymap.set("n", "<leader>ss", function()
  MiniExtra.pickers.lsp { scope = "document_symbol" }
end, { silent = true, desc = "Search symbols" })

vim.keymap.set("n", "<leader>sS", function()
  MiniExtra.pickers.lsp { scope = "workspace_symbol" }
end, { silent = true, desc = "Search all symbols" })
