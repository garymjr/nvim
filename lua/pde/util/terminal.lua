local M = {}
local H = {}

H.bufnr = nil
H.winnr = nil

---@param opts? table Options for the floating window.
function H.open_floating_window(opts)
  local screen_width = vim.o.columns
  local screen_height = vim.o.lines

  local width = math.floor(screen_width * 0.8)
  local height = math.floor(screen_height * 0.8)

  local row = (screen_height - height) / 2
  local col = (screen_width - width) / 2

  -- Default options
  local default_opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
    title = "",
    title_pos = "center",
  }

  local default_keys = {
    { "n", "q", M.close },
    { "n", "<leader>ft", M.close },
    { "t", "<esc><esc>", "<C-\\><C-n>" },
  }

  local cmd = opts and opts.cmd or nil
  if opts then
    opts.cmd = nil
  end

  local keys = opts and opts.keys or nil
  if opts then
    opts.keys = nil
  end

  keys = vim.tbl_extend("force", default_keys, keys or {})

  -- Merge user options with default options
  opts = vim.tbl_extend("force", default_opts, opts or {})

  local bufnr = H.bufnr
  if not cmd then
    if not (H.bufnr and vim.api.nvim_buf_is_valid(H.bufnr)) then
      bufnr = vim.api.nvim_create_buf(false, false)
      H.bufnr = bufnr
    end
  else
    bufnr = vim.api.nvim_create_buf(false, true)
  end

  -- Open the floating window
  H.winnr = vim.api.nvim_open_win(bufnr, true, opts)

  vim.api.nvim_set_current_win(H.winnr)

  if cmd then
    vim.fn.jobstart(cmd, {
      term = true,
      on_exit = function()
        M.close()
      end,
    })
  else
    if vim.bo[bufnr].buftype ~= "terminal" then
      vim.api.nvim_command "terminal"
    end
  end

  for _, key in ipairs(keys) do
    vim.keymap.set(key[1], key[2], key[3], { buffer = bufnr })
  end

  vim.cmd.startinsert()
end

---@param opts? table Options for the floating window.
function M.open(opts)
  H.open_floating_window(opts)
end

function M.close()
  if H.winnr and vim.api.nvim_win_is_valid(H.winnr) then
    vim.api.nvim_win_close(H.winnr, true)
    H.winnr = nil
  end
end

return M
