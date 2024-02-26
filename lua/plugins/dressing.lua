local add = MiniDeps.add
local now = MiniDeps.now

add("stevearc/dressing.nvim")

now(require("dressing").setup)
