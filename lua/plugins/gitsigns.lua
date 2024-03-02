MiniDeps.later(function()
  local gs = require("gitsigns")
  require("gitsigns").setup()
  vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { silent = true })
  vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { silent = true })

  vim.keymap.set(
    "v",
    "<leader>hs",
    function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end,
    { silent = true }
  )

  vim.keymap.set(
    "v",
    "<leader>hr",
    function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end,
    { silent = true }
  )

  vim.keymap.set("n", "<leader>hS", gs.stage_buffer, { silent = true })
  vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { silent = true })
  vim.keymap.set("n", "<leader>hR", gs.reset_buffer, { silent = true })
  vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { silent = true })

  vim.keymap.set(
    "n",
    "<leader>hb",
    function() gs.blame_line { full = true } end, { silent = true }
  )

  vim.keymap.set("n", "<leader>tb", gs.toggle_current_line_blame, { silent = true })
  vim.keymap.set("n", "<leader>td", gs.toggle_deleted, { silent = true })
end)
