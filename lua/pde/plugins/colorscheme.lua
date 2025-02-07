local now = MiniDeps.now

-- now(function()
--   require('kanagawa').setup({
--     keywordStyle = { italic = false },
--     colors = {
--       palette = {},
--       theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
--     },
--     overrides = function(colors)
--       return {}
--     end,
--   })
--
--   vim.cmd("colorscheme kanagawa")
-- end)

now(function()
  require("catppuccin").setup({
    flavour = "macchiato",
    integrations = {
      blink_cmp = { enabled = true },
      dashboard = true,
      mason = true,
      markdown = true,
      mini = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      notify = true,
      semantic_tokens = true,
      -- snacks = true,
      treesitter = true,
      treesitter_context = true,
      -- which_key = true,
    },
  })

  vim.cmd.colorscheme("catppuccin")
end)
