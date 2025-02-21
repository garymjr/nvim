local M = {}

---@class microvim.setup.opts
---@field deps? table[]
---@field options? table<string, string|number|boolean|table>
---@field keymaps? table[]
---@field autocmds? table[]

local function merge(t1, t2)
  local new_tbl = vim.deepcopy(t1)
  for _, item in ipairs(t2) do
    new_tbl[#new_tbl + 1] = item
  end
  return new_tbl
end

---@param deps table[]
function M._load_deps(deps)
  for _, spec in ipairs(deps) do
    MiniDeps.add(spec)
  end
end

---@param options table<string, string|number|boolean|table>
function M._load_options(options)
  for k, v in pairs(options) do
    vim.opt[k] = v
  end
end

---@param keymaps table[]
function M._load_keymaps(keymaps)
  for _, spec in ipairs(keymaps) do
    local lhs, rhs, opts = unpack(spec)

    local mode = "n"
    if opts.mode then
      mode = opts.mode
      opts.mode = nil
    end

    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

---@param autocmds table[]
function M._load_autocmds(autocmds)
  for _, spec in ipairs(autocmds) do
    local group = vim.api.nvim_create_augroup("microvim_" .. spec.name, { clear = true })

    vim.api.nvim_create_autocmd(spec.event, {
      group = group,
      pattern = spec.pattern,
      command = spec.command,
      callback = spec.callback,
    })
  end
end

function M.setup_diagnostics()
  vim.diagnostic.config {
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
      },
    },
  }
end

function M.setup_lsp()
  require("microvim.lsp").setup()
end

---@param config microvim.setup.opts
function M._setup(config)
  M._load_deps(config.deps)
  M._load_options(config.options)
  M._load_keymaps(config.keymaps)
  M._load_autocmds(config.autocmds)

  require "microvim.mini"
end

---@param opts? table
function M.setup(opts)
  opts = opts or {}

  -- set leader keys here so they're always available
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"

  local defaults = {
    deps = require "microvim.config.deps",
    options = require "microvim.config.options",
    keymaps = require "microvim.config.keymaps",
    autocmds = require "microvim.config.autocmds",
  }

  local config = {}
  for k, default in pairs(defaults) do
    if k == "options" then
      config[k] = vim.tbl_deep_extend("force", default, opts[k] or {})
    else
      config[k] = merge(default, opts[k] or {})
    end
  end

  M._setup(config)
  M.setup_diagnostics()
  M.setup_lsp()
end

---@class microvim
---@field setup fun(opts?: microvim.setup.opts)
---@field lazygit microvim.util.lazygit
---@field terminal microvim.util.terminal
local _meta = setmetatable({}, {
  __index = function(_, k)
    if M[k] then
      return M[k]
    end

    return require("microvim.util." .. k)
  end,
})

MicroVim = _meta
return _meta
