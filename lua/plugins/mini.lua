local now = MiniDeps.now
local later = MiniDeps.later

local function map(mode, lhs, rhs, opts)
	opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
	vim.keymap.set(mode, lhs, rhs, opts)
end

later(require("mini.ai").setup)
later(require("mini.bracketed").setup)

later(function()
  require("mini.bufremove").setup()
  map("n", "<leader>bd", MiniBufremove.delete, { desc = "Delete buffer" })
  map("n", "<leader>bD", function()
    MiniBufremove.delete(0, { force = true })
  end, { desc = "Delete buffer (force)" })
end)

later(function()
  local miniclue = require("mini.clue")
  miniclue.setup({
    triggers = {
      -- Leader triggers
      { mode = "n", keys = "<leader>" },
      { mode = "x", keys = "<leader>" },

      -- Built-in completion
      { mode = "i", keys = "<c-x>" },

      -- `g` key
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },

      -- Marks
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },

      -- Registers
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<c-r>" },
      { mode = "c", keys = "<c-r>" },

      -- Window commands
      { mode = "n", keys = "<c-w>" },

      -- `z` key
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
    },
    clues = {
      { mode = "n", keys = "<leader><tab>", desc = "+Tabs" },
      { mode = "n", keys = "<leader>b", desc = "+Buffers" },
      { mode = "n", keys = "<leader>b", desc = "+Buffers" },
      { mode = "n", keys = "<leader>c", desc = "+Code" },
      { mode = "n", keys = "<leader>f", desc = "+Find" },
      { mode = "n", keys = "<leader>g", desc = "+Git" },
      { mode = "n", keys = "<leader>s", desc = "+Search" },
      { mode = "n", keys = "<leader>u", desc = "+UI" },
      { mode = "n", keys = "<leader>w", desc = "+Windows" },
      { mode = "n", keys = "<leader>x", desc = "+Lists" },
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
  })
end)

later(require("mini.comment").setup)
later(function()
  require("mini.completion").setup({
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = function(items, base)
        -- Don't show 'Text' and 'Snippet' suggestions
        items = vim.tbl_filter(function(x) return x.kind ~= 1 and x.kind ~= 15 end, items)
        return MiniCompletion.default_process_items(items, base)
      end,
    },
  })
end)
later(require("mini.extra").setup)

later(function()
  require("mini.move").setup({
    mappings = {
      left = "<s-h>",
      right = "<s-l>",
      up = "<s-k>",
      down = "<s-j>",
      line_left = "",
      line_right = "",
      line_up = "",
      line_down = "",
    },
  })
end)

later(require("mini.notify").setup)

later(function()
  require("mini.pick").setup()
  map("n", "<leader>:", "<cmd>Pick history<cr>", { desc = "Command history" })
  map("n", "<leader>fb", "<cmd>Pick buffers include_current=false<cr>", { desc = "Buffers" })
  map("n", "<leader>fc", function()
    MiniPick.builtin.files({ tool = "fd" }, { source = { cwd = vim.fn.stdpath("config") } })
  end, { desc = "Config" })
  map("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "Files" })
  map("n", "<leader>fF", function()
    MiniPick.builtin.files({ tool = "fd" }, { source = { cwd = vim.uv.cwd() } })
  end, { desc = "Files (cwd)" })
  map("n", "<leader>fg", "<cmd>Pick git_files<cr>", { desc = "Files (git)" })
  map("n", "<leader>fr", "<cmd>Pick oldfiles<cr>", { desc = "Recent" })

  map("n", "<leader>gc", "<cmd>Pick git_commits<cr>", { desc = "Commits" })

  map("n", '<leader>s"', "<cmd>Pick registers<cr>", { desc = "Registers" })
  map("n", "<leader>sb", "<cmd>Pick buf_lines<cr>", { desc = "Buffer" })
  map("n", "<leader>sc", "<cmd>Pick commands<cr>", { desc = "Commands" })
  map("n", "<leader>sd", "<cmd>Pick scope='current'<cr>", { desc = "Document diagnostics" })
  map("n", "<leader>sD", "<cmd>Pick scope='all'<cr>", { desc = "Workspace diagnostics" })
  map("n", "<leader>sg", "<cmd>Pick grep_live<cr>", { desc = "Grep" })
  map("n", "<leader>sG", function()
    MiniPick.builtin.grep_live({ tool = "rg" }, { source = { cwd = vim.uv.cwd() } })
  end, { desc = "Grep" })
  map("n", "<leader>sh", "<cmd>Pick help<cr>", { desc = "Help pages" })
  map("n", "<leader>sH", "<cmd>Pick hl_groups<cr>", { desc = "Highlights" })
  map("n", "<leader>sk", "<cmd>Pick keymaps<cr>", { desc = "Keymaps" })
  map("n", "<leader>sm", "<cmd>Pick marks<cr>", { desc = "Marks" })
  map("n", "<leader>so", "<cmd>Pick options<cr>", { desc = "Options" })
  map("n", "<leader>sr", "<cmd>Pick resume<cr>", { desc = "Resume" })
  map("n", "<leader>ss", "<cmd>Pick lsp scope='document_symbol'<cr>", { desc = "Document symbol" })
  map("n", "<leader>sS", "<cmd>Pick lsp scope='workspace_symbol'<cr>", { desc = "Workspace symbol" })
end)

now(require("mini.statusline").setup)

later(function()
  require("mini.surround").setup({
    mappings = {
      add = "gsa",
      delete = "gsd",
      find = "gsf",
      find_left = "gsF",
      highlight = "gsh",
      replace = "gsr",
      update_n_lines = "gsn",
    },
  })
end)

now(require("mini.visits").setup)
