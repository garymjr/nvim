return {
  {
    name = "checktime",
    event = { "FocusGained", "TermClose", "TermLeave" },
    callback = function()
      if vim.o.buftype ~= "nofile" then
        vim.cmd "checktime"
      end
    end,
  },
  {
    name = "highlight_yank",
    event = "TextYankPost",
    callback = function()
      (vim.hl or vim.highlight).on_yank()
    end,
  },
  {
    name = "resize_splits",
    event = { "VimResized" },
    callback = function()
      local current_tab = vim.fn.tabpagenr()
      vim.cmd "tabdo wincmd ="
      vim.cmd("tabnext " .. current_tab)
    end,
  },
  {
    name = "close_with_q",
    event = "FileType",
    pattern = {
      "PlenaryTestPopup",
      "checkhealth",
      "dbout",
      "help",
      "lspinfo",
      "notify",
      "qf",
      "startuptime",
      "tsplayground",
    },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.schedule(function()
        vim.keymap.set("n", "q", function()
          vim.cmd "close"
          pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
        end, {
          buffer = event.buf,
          silent = true,
          desc = "Quit buffer",
        })
      end)
    end,
  },
  {
    name = "man_unlisted",
    event = "FileType",
    pattern = { "man" },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
    end,
  },
  {
    name = "wrap",
    event = "FileType",
    pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
    callback = function()
      vim.opt_local.wrap = true
    end,
  },
  {
    name = "json_conceal",
    event = { "FileType" },
    pattern = { "json", "jsonc", "json5" },
    callback = function()
      vim.opt_local.conceallevel = 0
    end,
  },
  {
    name = "auto_create_dir",
    event = { "BufWritePre" },
    callback = function(event)
      if event.match:match "^%w%w+:[\\/][\\/]" then
        return
      end
      local file = vim.uv.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
  },
}
