local add, now = MiniDeps.add, MiniDeps.now

add "olivercederborg/poimandres.nvim"

now(function()
  require("poimandres").setup()

  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "poimandres",
    callback = function()
      vim.api.nvim_set_hl(0, "LspReferenceText", { fg = "#e4f0fb", bg = "#506477" })
    end,
  })

  vim.cmd.colorscheme "poimandres"
end)

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

-- now(function()
--     require("catppuccin").setup {
--         flavour = "macchiato",
--         integrations = {
--             blink_cmp = { enabled = true },
--             dashboard = true,
--             mason = true,
--             markdown = true,
--             mini = true,
--             native_lsp = {
--                 enabled = true,
--                 underlines = {
--                     errors = { "undercurl" },
--                     hints = { "undercurl" },
--                     warnings = { "undercurl" },
--                     information = { "undercurl" },
--                 },
--             },
--             notify = true,
--             semantic_tokens = true,
--             -- snacks = true,
--             treesitter = true,
--             treesitter_context = true,
--             -- which_key = true,
--         },
--     }
--
--     vim.cmd.colorscheme "catppuccin"
-- end)
