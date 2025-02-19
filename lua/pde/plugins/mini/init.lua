local now, later = MiniDeps.now, MiniDeps.later

now(function() require("mini.extra").setup() end)

later(function() require("mini.ai").setup() end)

later(function() require("mini.bracketed").setup() end)

later(function()
  require("mini.bufremove").setup()

  vim.keymap.set("n", "<leader>bd", MiniBufremove.wipeout, { desc = "Delete Buffer" })
  vim.keymap.set(
    "n",
    "<leader>bD",
    function() MiniBufremove.wipeout(0, true) end,
    { desc = "Delete Buffer (force)" }
  )
end)

now(function() require "pde.plugins.mini.clue" end)

later(
  function()
    require("mini.diff").setup {
      view = {
        style = "sign",
        signs = {
          add = "▎",
          change = "▎",
          delete = "",
        },
      },
    }
  end
)

later(function() require "pde.plugins.mini.files" end)

later(function() require("mini.git").setup() end)

now(function()
  require("mini.icons").setup()
  MiniIcons.mock_nvim_web_devicons()
end)

now(function()
  require("mini.notify").setup()

  vim.notify = MiniNotify.make_notify()
end)

later(function() require "pde.plugins.mini.pick" end)

now(function() require("mini.statusline").setup() end)

later(
  function()
    require("mini.surround").setup {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    }
  end
)
