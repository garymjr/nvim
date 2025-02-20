---@class microvim.util.lazygit
---@overload fun()
local M = {}

---@alias microvim.util.lazygit.Color {fg?:string, bg?:string, bold?:boolean}

---@class microvim.lazygit.Theme: table<number, microvim.lazygit.Color>
---@field activeBorderColor microvim.util.lazygit.Color
---@field cherryPickedCommitBgColor microvim.util.lazygit.Color
---@field cherryPickedCommitFgColor microvim.util.lazygit.Color
---@field defaultFgColor microvim.util.lazygit.Color
---@field inactiveBorderColor microvim.util.lazygit.Color
---@field optionsTextColor microvim.util.lazygit.Color
---@field searchingActiveBorderColor microvim.util.lazygit.Color
---@field selectedLineBgColor microvim.util.lazygit.Color
---@field unstagedChangesColor microvim.util.lazygit.Color

---@class microvim.lazygit.Config
---@field args? string[]
---@field theme? microvim.lazygit.Theme
local H = {
  args = {},
  dirty = true,
  theme_path = vim.fs.normalize(vim.fn.stdpath "cache" .. "/lazygit-theme.yml"),
  theme = {
    [241] = { fg = "Special" },
    activeBorderColor = { fg = "MatchParen", bold = true },
    cherryPickedCommitBgColor = { fg = "Identifier" },
    cherryPickedCommitFgColor = { fg = "Function" },
    defaultFgColor = { fg = "Normal" },
    inactiveBorderColor = { fg = "FloatBorder" },
    optionsTextColor = { fg = "Function" },
    searchingActiveBorderColor = { fg = "MatchParen", bold = true },
    selectedLineBgColor = { bg = "Visual" }, -- set to `default` to have no background colour
    unstagedChangesColor = { fg = "DiagnosticError" },
  },
}

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    H.dirty = true
  end,
})

function H.env()
  if not H.config_dir then
    local out = vim.fn.system { "lazygit", "-cd" }
    local lines = vim.split(out, "\n", { plain = true })

    if vim.v.shell_error == 0 and #lines > 1 then
      H.config_dir = vim.split(lines[1], "\n", { plain = true })[1]

      local config_files = vim.tbl_filter(function(v)
        return v:match "%S"
      end, vim.split(vim.env.LG_CONFIG_FILE or "", ",", { plain = true }))

      if #config_files == 0 then
        config_files[1] = vim.fs.normalize(H.config_dir .. "/config.yml")
      end

      if not vim.tbl_contains(config_files, H.theme_path) then
        table.insert(config_files, H.theme_path)
      end

      vim.env.LG_CONFIG_FILE = table.concat(config_files, ",")
    end
  end
end

---@param value microvim.util.lazygit.Color
---@return string[]
function H.get_color(value)
  local color = {}
  for _, v in ipairs { "fg", "bg" } do
    if value[v] then
      local name = value[v]
      local hl = vim.api.nvim_get_hl(0, { name = name, link = false })

      local hl_color
      if v == "fg" then
        hl_color = hl and hl.fg
      else
        hl_color = hl and hl.bg
      end

      if hl_color then
        table.insert(color, string.format("#%06x", hl_color))
      end
    end
  end
  if value.bold then
    table.insert(color, "bold")
  end
  return color
end

function H.update_config()
  local theme = {}

  for k, v in pairs(H.theme) do
    if type(k) == "number" then
      local color = H.get_color(v)
      pcall(io.write, ("\27]4;%d;%s\7"):format(k, color[1]))
    else
      theme[k] = H.get_color(v)
    end
  end

  local config = { gui = { theme = theme } }

  local function yaml_val(val)
    if type(val) == "boolean" then
      return tostring(val)
    end
    return type(val) == "string" and not val:find "^\"'`" and ("%q"):format(val) or val
  end

  local function to_yaml(tbl, indent)
    indent = indent or 0
    local lines = {}
    for k, v in pairs(tbl) do
      table.insert(
        lines,
        string.rep(" ", indent) .. k .. (type(v) == "table" and ":" or ": " .. yaml_val(v))
      )
      if type(v) == "table" then
        if vim.islist(v) then
          for _, item in ipairs(v) do
            table.insert(lines, string.rep(" ", indent + 2) .. "- " .. yaml_val(item))
          end
        else
          vim.list_extend(lines, to_yaml(v, indent + 2))
        end
      end
    end
    return lines
  end
  vim.fn.writefile(to_yaml(config), H.theme_path)
  H.dirty = false
end

function M.open()
  local cmd = { "lazygit" }
  vim.list_extend(cmd, H.args or {})

  H.env()
  if H.dirty then
    H.update_config()
  end

  MicroVim.terminal.open { cmd = cmd }
end

return M
