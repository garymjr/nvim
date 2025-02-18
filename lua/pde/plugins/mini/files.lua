local H = {}

H.show_dotfiles = false
function H.filter_show()
  return true
end

function H.filter_hide(fs_entry)
  return not vim.startswith(fs_entry.name, ".")
end

function H.toggle_dotfiles()
  H.show_dotfiles = not H.show_dotfiles
  local new_filter = H.show_dotfiles and H.filter_show or H.filter_hide
  require("mini.files").refresh({ content = { filter = new_filter } })
end

vim.keymap.set("n", "-", function()
  MiniFiles.open(vim.fn.expand("%"))
end, { silent = true })

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id

    vim.keymap.set(
      "n",
      "g.",
      H.toggle_dotfiles,
      { buffer = buf_id, desc = "Toggle hidden files" }
    )
  end,
})

require("mini.files").setup({
  content = {
    filter = H.filter_hide,
  },
})
