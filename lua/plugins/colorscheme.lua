return {
  {
    "olivercederborg/poimandres.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      require("poimandres").setup(opts)

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "poimandres",
        callback = function()
          vim.api.nvim_set_hl(0, "LspReferenceText", { fg = "#e4f0fb", bg = "#506477" })
          vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = "#1b1e28", bg = "#5de4c7" })
        end,
      })

      vim.cmd.colorscheme "poimandres"
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "main",
      styles = {
        italic = false,
      },
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      vim.cmd.colorscheme "rose-pine"
    end,
  },
}
