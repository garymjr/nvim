---@class microvim.util.path
---@overload fun(path: string): microvim.util.path
local Path = {}

---@param path string
---@return microvim.util.path
function Path:new(path)
  self.path = path
  return self
end

---@return string
function Path:dirname()
  if self:is_file() then
    return vim.fn.fnamemodify(self.path, ":h")
  else
    return self.path
  end
end

---@param dirname? string
---@return boolean
function Path:exists(dirname)
  local path = dirname or self.path
  local stat = vim.uv.fs_stat(path)
  return stat ~= nil
end

---@return boolean
function Path:is_directory()
  local stat = vim.uv.fs_stat(self.path)
  if not stat then
    return vim.fn.fnamemodify(self.path, ":t"):match "%.[^%.]+$" == nil
  end
  return stat.type == "directory"
end

---@return boolean
function Path:is_file()
  local stat = vim.uv.fs_stat(self.path)
  if not stat then
    return vim.fn.fnamemodify(self.path, ":t"):match "%.[^%.]+$" ~= nil
  end
  return stat.type == "file"
end

---@return boolean
function Path:create()
  if not self:exists() then
    if self:is_directory() then
      vim.print(string.format("dir: %q", self:is_directory()))
      return vim.fn.mkdir(self.path, "p") == 1
    end
    if self:is_file() then
      local dirname = self:dirname()
      vim.print(string.format("file: %q", self:is_file()))
      return vim.fn.mkdir(dirname, "p") == 1
    end
  end
  return false
end

---@param path string
---@return microvim.util.path
function Path:join(path)
  return Path:new(vim.fn.join({ self.path, path }, "/"))
end

---@return string
function Path:get()
  return self.path
end

return setmetatable({}, {
  __index = Path,
  __call = function(self, path)
    return self:new(path)
  end,
})
