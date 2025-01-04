return {
  {
    "saghen/blink.cmp",
    version = "*",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.default",
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
      {
        "saghen/blink.compat",
        version = "*",
        opts = {},
      },
    },
    event = "InsertEnter",
    opts = {
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        ghost_text = {
          enabled = false,
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        cmdline = {},
      },
      keymap = { preset = "enter" },
    },
  },
}
