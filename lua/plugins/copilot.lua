-- <Tab>: Accept the current suggestion.
-- <C-J>: Accept the suggestion (if <Tab> is not used).
-- <C-L>: Accept one word of the current suggestion.
-- <C-]>: Dismiss the current suggestion.
-- <M-]>: Cycle to the next suggestion.
-- <M-[>: Cycle to the previous suggestion.
-- <M-\>: Explicitly request a suggestion.
-- <M-Right>: Accept the next word of the current suggestion.
-- <M-C-Right>: Accept the next line of the current suggestion.

return {
  {
    "github/copilot.vim",
    event = "VeryLazy",
    cmd = "Copilot",
    keys = {
      {"<c-l>", "<plug>(copilot-next)", mode ="i" },
      {"<c-h>", "<plug>(copilot-previous)", mode ="i" },
      {"<c-d>", "<plug>(copilot-dismiss)", mode ="i" },
      {"<c-u>", "<plug>(copilot-suggest)", mode ="i" },
      {"<c-;>", "<plug>(copilot-accept-word)", mode ="i" },
    },
  },
}
