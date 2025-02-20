local now, later = MiniDeps.now, MiniDeps.later

local H = {}

now(function()
  require("mini.extra").setup()
end)

later(function()
  require("mini.ai").setup()
end)

later(function()
  require("mini.bracketed").setup()
end)

later(function()
  require("mini.bufremove").setup()
end)

now(function()
  local miniclue = require "mini.clue"

  miniclue.setup {
    triggers = {
      { mode = "n", keys = "<Leader>" },
      { mode = "n", keys = "g" },
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "n", keys = '"' },
      { mode = "n", keys = "<C-w>" },
      { mode = "n", keys = "z" },

      { mode = "x", keys = "<Leader>" },
      { mode = "x", keys = "g" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },
      { mode = "x", keys = '"' },
      { mode = "x", keys = "z" },

      { mode = "i", keys = "<C-x>" },
      { mode = "i", keys = "<C-r>" },

      { mode = "c", keys = "<C-r>" },
    },
    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
      { mode = "n", keys = "<leader>a", desc = "+ai" },
      { mode = "x", keys = "<leader>a", desc = "+ai" },
    },
  }
end)

later(function()
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
end)

later(function()
  H.files__show_dotfiles = false
  function H.files__filter_show()
    return true
  end

  function H.files__filter_hide(fs_entry)
    return not vim.startswith(fs_entry.name, ".")
  end

  function H.files__toggle_dotfiles()
    H.files__show_dotfiles = not H.files__show_dotfiles
    local new_filter = H.files__show_dotfiles and H.files__filter_show or H.files__filter_hide
    require("mini.files").refresh { content = { filter = new_filter } }
  end

  require("mini.files").setup {
    content = {
      filter = H.files__filter_hide,
    },
  }
end)

later(function()
  require("mini.git").setup()
end)

now(function()
  require("mini.icons").setup()
  MiniIcons.mock_nvim_web_devicons()
end)

now(function()
  require("mini.notify").setup()

  vim.notify = MiniNotify.make_notify()
end)

later(function()
  local function win_config()
    local height = math.floor(0.618 * vim.o.lines)
    local width = math.floor(0.618 * vim.o.columns)
    return {
      anchor = "NW",
      height = height,
      width = width,
      row = math.floor(0.5 * (vim.o.lines - height)),
      col = math.floor(0.5 * (vim.o.columns - width)),
    }
  end

  require("mini.pick").setup {
    mappings = {
      scroll_down = "<C-j>",
      scroll_left = "<C-h>",
      scroll_right = "<C-l>",
      scroll_up = "<C-k>",
    },
    window = { config = win_config },
  }
end)

now(function()
  require("mini.statusline").setup()
end)

later(function()
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
end)

later(function()
  -- bufremove
  vim.keymap.set("n", "<leader>bd", function()
    MiniBufremove.delete()
  end, { desc = "Delete Buffer" })
  vim.keymap.set("n", "<leader>bD", function()
    MiniBufremove.delete(0, true)
  end, { desc = "Delete Buffer (force)" })

  -- files
  vim.keymap.set("n", "-", function()
    MiniFiles.open(vim.fn.expand "%")
  end, { silent = true })

  -- pick
  vim.keymap.set("n", "<leader>fb", function()
    MiniPick.builtin.buffers { include_current = false }
  end, { silent = true, desc = "Find buffers" })

  vim.keymap.set("n", "<leader>fc", function()
    MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath "config" } })
  end, { silent = true, desc = "Find config" })

  vim.keymap.set("n", "<leader>ff", function()
    MiniPick.builtin.files()
  end, { silent = true, desc = "Find files" })

  vim.keymap.set("n", "<leader>fp", function()
    MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath "data" .. "/site/pack/deps" } })
  end, { silent = true, desc = "Find plugins" })

  vim.keymap.set("n", "<leader>fr", function()
    MiniExtra.pickers.oldfiles { current_dir = true }
  end, { silent = true, desc = "Find recent files (cwd)" })

  vim.keymap.set("n", "<leader>fR", function()
    MiniExtra.pickers.oldfiles()
  end, { silent = true, desc = "Find recent files" })

  vim.keymap.set("n", "<leader>sd", function()
    MiniExtra.pickers.diagnostic { scope = "current" }
  end, { silent = true, desc = "Search diagnostics" })

  vim.keymap.set("n", "<leader>sD", function()
    MiniExtra.pickers.diagnostic()
  end, { silent = true, desc = "Search all diagnostics" })

  vim.keymap.set("n", "<leader>sh", function()
    MiniPick.builtin.help()
  end, { silent = true, desc = "Search help" })

  vim.keymap.set("n", "<leader>sg", function()
    MiniPick.builtin.grep_live()
  end, { silent = true, desc = "Search grep" })

  vim.keymap.set("n", "<leader>sR", function()
    MiniPick.builtin.resume()
  end, { silent = true, desc = "Search resume" })

  vim.keymap.set("n", "<leader>ss", function()
    MiniExtra.pickers.lsp { scope = "document_symbol" }
  end, { silent = true, desc = "Search symbols" })

  vim.keymap.set("n", "<leader>sS", function()
    MiniExtra.pickers.lsp { scope = "workspace_symbol" }
  end, { silent = true, desc = "Search all symbols" })
end)

later(function()
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      local buf_id = args.data.buf_id

      vim.keymap.set(
        "n",
        "g.",
        H.files__toggle_dotfiles,
        { buffer = buf_id, desc = "Toggle hidden files" }
      )
    end,
  })
end)

later(function()
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.select = function(items, opts, on_choice)
    local height = math.floor(0.218 * vim.o.lines)
    local width = math.floor(0.5 * vim.o.columns)
    local row = math.floor(0.5 * (vim.o.lines - height))
    local col = math.floor(0.5 * (vim.o.columns - width))

    MiniPick.ui_select(items, opts, on_choice, {
      window = {
        config = {
          anchor = "NW",
          height = height,
          width = width,
          row = row,
          col = col,
        },
      },
    })
  end
end)
