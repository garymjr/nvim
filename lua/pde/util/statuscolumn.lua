local M = setmetatable({}, {
  __call = function(t) return t.get() end,
})

local LINE_NR = "%=%{%(&number || &relativenumber) && v:virtnum == 0 ? ("
  .. (vim.fn.has "nvim-0.11" == 1 and '"%l"' or 'v:relnum == 0 ? (&number ? "%l" : "%r") : (&relativenumber ? "%r" : "%l")')
  .. ') : ""%} '

local config = {
  enabled = true,
  left = { "mark", "sign" }, -- priority of signs on the left (high to low)
  right = { "fold", "git" }, -- priority of signs on the right (high to low)
  folds = {
    open = false, -- show open fold icons
    git_hl = false, -- use Git Signs hl for fold icons
  },
  git = {
    -- patterns to match Git signs
    patterns = { "GitSign", "MiniDiffSign" },
  },
  refresh = 50, -- refresh at most every 50ms
}

local sign_cache = {}
local cache = {} ---@type table<string,string>
local icon_cache = {} ---@type table<string,string>

local did_setup = false

function M.setup()
  if did_setup then
    return
  end

  did_setup = true
  vim.api.nvim_set_hl(0, "PDEStausColumnMark", { default = true, link = "DiagnosticHint" })
  local timer = assert(vim.uv.new_timer())
  timer:start(config.refresh, config.refresh, function()
    sign_cache = {}
    cache = {}
  end)
end

function M.is_git_sign(name)
  for _, pattern in ipairs(config.git.patterns) do
    if name:find(pattern) then
      return true
    end
  end
end

function M.buf_signs(buf)
  local signs = {}

  local extmarks = vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, { details = true, type = "sign" })
  for _, extmark in pairs(extmarks) do
    local lnum = extmark[2] + 1
    signs[lnum] = signs[lnum] or {}
    local name = extmark[4].sign_hl_group or extmark[4].sign_name or ""
    table.insert(signs[lnum], {
      name = name,
      type = M.is_git_sign(name) and "git" or "sign",
      text = extmark[4].sign_text,
      texthl = extmark[4].sign_hl_group,
      priority = extmark[4].priority,
    })
  end

  local marks = vim.fn.getmarklist(buf)
  vim.list_extend(marks, vim.fn.getmarklist())
  for _, mark in ipairs(marks) do
    if mark.pos[1] == buf and mark.mark:match "[a-zA-Z]" then
      local lnum = mark.pos[2]
      signs[lnum] = signs[lnum] or {}
      table.insert(
        signs[lnum],
        { text = mark.mark:sub(2), texthl = "PDEStatusColumnMark", type = "mark" }
      )
    end
  end

  return signs
end

function M.line_signs(win, buf, lnum)
  local buf_signs = sign_cache[buf]
  if not buf_signs then
    buf_signs = M.buf_signs(buf)
    sign_cache[buf] = buf_signs
  end
  local signs = buf_signs[lnum] or {}

  -- Get fold signs
  vim.api.nvim_win_call(win, function()
    if vim.fn.foldclosed(lnum) >= 0 then
      signs[#signs + 1] =
        { text = vim.opt.fillchars:get().foldclose or "", texthl = "Folded", type = "fold" }
    elseif config.folds.open and tostring(vim.treesitter.foldexpr(vim.v.lnum)):sub(1, 1) == ">" then
      signs[#signs + 1] = { text = vim.opt.fillchars:get().foldopen or "", type = "fold" }
    end
  end)

  -- Sort by priority
  table.sort(signs, function(a, b) return (a.priority or 0) > (b.priority or 0) end)
  return signs
end

function M.icon(sign)
  if not sign then
    return "  "
  end
  local key = (sign.text or "") .. (sign.texthl or "")
  if icon_cache[key] then
    return icon_cache[key]
  end
  local text = vim.fn.strcharpart(sign.text or "", 0, 2) ---@type string
  text = text .. string.rep(" ", 2 - vim.fn.strchars(text))
  icon_cache[key] = sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
  return icon_cache[key]
end

---@return string
function M._get()
  if not did_setup then
    M.setup()
  end
  local win = vim.g.statusline_winid
  local show_signs = vim.v.virtnum == 0 and vim.wo[win].signcolumn ~= "no"
  local components = { "", LINE_NR, "" } -- left, middle, right
  if not show_signs and not (vim.wo[win].number or vim.wo[win].relativenumber) then
    return ""
  end

  if show_signs then
    local buf = vim.api.nvim_win_get_buf(win)
    local is_file = vim.bo[buf].buftype == ""
    local signs = M.line_signs(win, buf, vim.v.lnum)

    if #signs > 0 then
      local signs_by_type = {}
      for _, s in ipairs(signs) do
        signs_by_type[s.type] = signs_by_type[s.type] or s
      end

      local function find(types)
        for _, t in ipairs(types) do
          if signs_by_type[t] then
            return signs_by_type[t]
          end
        end
      end

      local left_c = type(config.left) == "function" and config.left(win, buf, vim.v.lnum)
        or config.left
      local right_c = type(config.right) == "function" and config.right(win, buf, vim.v.lnum)
        or config.right
      local left, right = find(left_c), find(right_c)

      if config.folds.git_hl then
        local git = signs_by_type.git
        if git and left and left.type == "fold" then
          left.texthl = git.texthl
        end
        if git and right and right.type == "fold" then
          right.texthl = git.texthl
        end
      end
      components[1] = left and M.icon(left) or "  " -- left
      components[3] = is_file and (right and M.icon(right) or "  ") or "" -- right
    else
      components[1] = "  "
      components[3] = is_file and "  " or ""
    end
  end

  local ret = table.concat(components, "")
  return "%@v:lua.require'pde.util.statuscolumn'.click_fold@" .. ret .. "%T"
end

function M.get()
  local win = vim.g.statusline_winid
  local buf = vim.api.nvim_win_get_buf(win)
  local key = ("%d:%d:%d:%d"):format(win, buf, vim.v.lnum, vim.v.virtnum ~= 0 and 1 or 0)
  if cache[key] then
    return cache[key]
  end
  local ok, ret = pcall(M._get)
  if ok then
    cache[key] = ret
    return ret
  end
  return ""
end

---@private
function M.health()
  local ready = vim.o.statuscolumn:find("pde.util.statuscolumn", 1, true)
  if config.enabled and not ready then
    vim.notify("pde.util.statuscolumn is not configured", vim.log.levels.WARN)
  end
end

function M.click_fold()
  local pos = vim.fn.getmousepos()
  vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 1 })
  vim.api.nvim_win_call(pos.winid, function()
    if vim.fn.foldlevel(pos.line) > 0 then
      vim.cmd "normal! za"
    end
  end)
end

return M
