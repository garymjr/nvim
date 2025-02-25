-- -- Fix markdown indentation settings
-- vim.g.markdown_recommended_style = 0

vim.g.copilot_filetypes = {
  [""] = false,
}

return {
  clipboard = vim.env.SSH_TTY and "" or "unnamedplus",
  completeopt = "menu,menuone,noselect",
  conceallevel = 2,
  confirm = true,
  expandtab = true,
  fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " ",
  },
  foldexpr = "v:lua.MicroVim.util.foldexpr()",
  foldlevel = 99,
  foldmethod = "expr",
  formatoptions = "jcroqlnt",
  grepformat = "%f:%l:%c:%m",
  grepprg = "rg --vimgrep",
  ignorecase = true,
  inccommand = "nosplit",
  jumpoptions = "view",
  laststatus = 3,
  linebreak = true,
  mouse = "a",
  number = true,
  pumblend = 10,
  pumheight = 10,
  relativenumber = true,
  ruler = false,
  scrolloff = 4,
  shiftround = true,
  shiftwidth = 2,
  shortmess = { W = true, I = true, c = true, C = true },
  showmode = false,
  sidescrolloff = 8,
  signcolumn = "yes",
  smartcase = true,
  smartindent = true,
  smoothscroll = true,
  splitbelow = true,
  splitkeep = "screen",
  splitright = true,
  statuscolumn = "%!v:lua.MicroVim.statuscolumn.get()",
  swapfile = false,
  tabstop = 2,
  termguicolors = true,
  timeoutlen = 300,
  undofile = true,
  undolevels = 10000,
  updatetime = 200,
  virtualedit = "block",
  wildmode = "longest:full,full",
  winminwidth = 5,
  wrap = false,
}
