-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })
MiniDeps.add({
  source = "echasnovski/mini.nvim",
  checkout = "HEAD",
})

local now, later = MiniDeps.now, MiniDeps.later

local function map(mode, lhs, rhs, opts)
  opts = vim.tbl_deep_extend("force", {}, opts or {}, { silent = true })
  vim.keymap.set(mode, lhs, rhs, opts)
end

now(function()
  require("config.autocmds")
  require("config.options")
  require("config.keymaps")
end)

later(function()
  -- palette based on catppuccin
  local palette = require("mini.base16").mini_palette("#1e1e2e", "#cdd6f4", 50)
  require("mini.base16").setup({ palette = palette })
end)


-- MiniDeps.add({
--   source = "catppuccin/nvim",
--   name = "catppuccin",
-- })

-- require_now(function()
--   require("catppuccin").setup({
--     term_colors = true,
--     styles = {
--       conditionals = {},
--     },
--     custom_highlights = function(colors)
--       local O = require("catppuccin.utils.colors")
--
--       return {
--         MiniCompletionActiveParameter = { style = { "underline" } },
--
--         MiniCursorword = { style = { "underline" } },
--         MiniCursorwordCurrent = { style = { "underline" } },
--
--         MiniIndentscopeSymbol = { fg = colors.text },
--         MiniIndentscopePrefix = { style = { "nocombine" } }, -- Make it invisible
--
--         MiniJump = { fg = colors.overlay2, bg = colors.pink },
--
--         MiniJump2dSpot = { bg = colors.base, fg = colors.peach, style = { "bold", "underline" } },
--
--         MiniStarterCurrent = {},
--         MiniStarterFooter = { fg = colors.yellow, style = { "italic" } },
--         MiniStarterHeader = { fg = colors.blue },
--         MiniStarterInactive = { fg = colors.surface2, style = { "italic" } },
--         MiniStarterItem = { fg = colors.text },
--         MiniStarterItemBullet = { fg = colors.blue },
--         MiniStarterItemPrefix = { fg = colors.pink },
--         MiniStarterSection = { fg = colors.flamingo },
--         MiniStarterQuery = { fg = colors.green },
--
--         MiniStatuslineDevinfo = { fg = colors.subtext1, bg = colors.surface1 },
--         MiniStatuslineFileinfo = { fg = colors.subtext1, bg = colors.surface1 },
--         MiniStatuslineFilename = { fg = colors.text, bg = colors.mantle },
--         MiniStatuslineInactive = { fg = colors.blue, bg = colors.mantle },
--         MiniStatuslineModeCommand = { fg = colors.base, bg = colors.peach, style = { "bold" } },
--         MiniStatuslineModeInsert = { fg = colors.base, bg = colors.green, style = { "bold" } },
--         MiniStatuslineModeNormal = { fg = colors.mantle, bg = colors.blue, style = { "bold" } },
--         MiniStatuslineModeOther = { fg = colors.base, bg = colors.teal, style = { "bold" } },
--         MiniStatuslineModeReplace = { fg = colors.base, bg = colors.red, style = { "bold" } },
--         MiniStatuslineModeVisual = { fg = colors.base, bg = colors.mauve, style = { "bold" } },
--
--         MiniSurround = { bg = colors.pink, fg = colors.surface1 },
--
--         MiniTablineCurrent = { fg = colors.text, bg = colors.base, sp = colors.red, style = { "bold", "italic", "underline" } },
--         MiniTablineFill = { bg = colors.base },
--         MiniTablineHidden = { fg = colors.text, bg = colors.mantle },
--         MiniTablineModifiedCurrent = { fg = colors.red, bg = colors.none, style = { "bold", "italic" } },
--         MiniTablineModifiedHidden = { fg = colors.red, bg = colors.none },
--         MiniTablineModifiedVisible = { fg = colors.red, bg = colors.none },
--         MiniTablineTabpagesection = { fg = colors.surface1, bg = colors.base },
--         MiniTablineVisible = { bg = colors.none },
--
--         MiniTestEmphasis = { style = { "bold" } },
--         MiniTestFail = { fg = colors.red, style = { "bold" } },
--         MiniTestPass = { fg = colors.green, style = { "bold" } },
--
--         MiniTrailspace = { bg = colors.red },
--       }
--     end,
--     integrations = {
--       mason = true,
--       native_lsp = {
--         enabled = true,
--         virtual_text = {
--           errors = {},
--           hints = { "italic" },
--           warnings = {},
--           information = { "italic" },
--         },
--         underlines = {
--           errors = { "underline" },
--           hints = { "underline" },
--           warnings = { "underline" },
--           information = { "underline" },
--         },
--         inlay_hints = {
--           background = true,
--         },
--       },
--     },
--   })
--
--   vim.cmd.colorscheme("catppuccin")
-- end)

now(function()
  require('mini.notify').setup()
  vim.notify = MiniNotify.make_notify()
end)

now(function() require("mini.statusline").setup() end)

later(function() require("mini.extra").setup() end)
later(function() require("mini.ai").setup() end)
later(function() require("mini.bracketed").setup() end)

later(function()
  require("mini.bufremove").setup()
  map("n", "<leader>bd", MiniBufremove.delete, { desc = "Delete buffer" })
  map("n", "<leader>bD", function()
    MiniBufremove.delete(0, true)
  end, { desc = "Delete buffer (force)" })
end)

later(function()
  local clue = require("mini.clue")
  clue.setup({
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

      -- mini.bracketed
      { mode = "n", keys = "[" },
      { mode = "n", keys = "]" },
      { mode = "x", keys = "[" },
      { mode = "x", keys = "]" },
    },
    clues = {
      { mode = "n", keys = "<leader><tab>", desc = "+Tabs" },
      { mode = "n", keys = "<leader>b",     desc = "+Buffers" },
      { mode = "n", keys = "<leader>b",     desc = "+Buffers" },
      { mode = "n", keys = "<leader>c",     desc = "+Code" },
      { mode = "n", keys = "<leader>f",     desc = "+Find" },
      { mode = "n", keys = "<leader>g",     desc = "+Git" },
      { mode = "n", keys = "<leader>s",     desc = "+Search" },
      { mode = "n", keys = "<leader>u",     desc = "+UI" },
      { mode = "n", keys = "<leader>w",     desc = "+Windows" },
      { mode = "n", keys = "<leader>x",     desc = "+Lists" },
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.windows(),
      clue.gen_clues.z(),
    },
  })
end)

later(function() require("mini.comment").setup() end)

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

later(function() require("mini.visits").setup() end)

require("plugins")
