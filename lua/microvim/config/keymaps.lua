local diagnostic_goto = function(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { severity = severity, count = next and 1 or -1 }
  end
end

return {
  {
    "j",
    "v:count == 0 ? 'gj' : 'j'",
    { desc = "Down", expr = true, silent = true, mode = { "n", "x" } },
  },
  {
    "k",
    "v:count == 0 ? 'gk' : 'k'",
    { desc = "Up", expr = true, silent = true, mode = { "n", "x" } },
  },
  { "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true, mode = { "n", "v" } } },
  { "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true, mode = { "n", "v" } } },
  { "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true, mode = { "n", "v" } } },
  { "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true, mode = { "n", "v" } } },
  {
    "J",
    ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",
    { desc = "Move Down", mode = "v" },
  },
  {
    "K",
    ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",
    { desc = "Move Up", mode = "v" },
  },
  { "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" } },
  { "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" } },
  { "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" } },
  { "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" } },
  { "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" } },
  { "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" } },
  {
    "<esc>",
    function()
      vim.cmd "noh"
      vim.snippet.stop()
      return "<esc>"
    end,
    { expr = true, desc = "Escape and Clear hlsearch", mode = { "i", "n", "s" } },
  },
  { ",", ",<c-g>u", { mode = "i" } },
  { ".", ".<c-g>u", { mode = "i" } },
  { ";", ";<c-g>u", { mode = "i" } },
  { "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" } },
  { "<", "<gv", { mode = "v" } },
  { ">", ">gv", { mode = "v" } },
  { "<leader>fn", "<cmd>enew<cr>", { desc = "New File" } },
  { "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" } },
  { "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" } },
  { "[q", vim.cmd.cprev, { desc = "Previous Quickfix" } },
  { "]q", vim.cmd.cnext, { desc = "Next Quickfix" } },
  { "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" } },
  { "]d", diagnostic_goto(true), { desc = "Next Diagnostic" } },
  { "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" } },
  { "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" } },
  { "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" } },
  { "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" } },
  { "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" } },
  {
    "<leader>ft",
    function()
      MicroVim.terminal.open()
    end,
    { desc = "Toggle terminal" },
  },
  {
    "<leader>gg",
    function()
      MicroVim.lazygit.open()
    end,
    { desc = "Toggle laygit" },
  },
  { "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" } },
  { "<leader>ui", vim.show_pos, { desc = "Inspect Pos" } },
  { "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" } },
  { "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal", mode = "t" } },
  { "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore", mode = "t" } },
  { "<leader>w", "<c-w>", { desc = "Windows", remap = true } },
  { "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true } },
  { "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true } },
  { "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true } },
  { "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" } },
  { "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" } },
  { "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" } },
  { "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" } },
  { "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" } },
  { "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" } },
  { "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" } },
}
