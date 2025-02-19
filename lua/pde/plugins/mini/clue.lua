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
  },
}
