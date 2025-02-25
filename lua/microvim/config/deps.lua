return {
  { source = "github/copilot.vim" },
  {
    source = "Saghen/blink.cmp",
    checkout = "v0.12.4",
    monitor = "main",
    depends = { "kristijanhusak/vim-dadbod-completion" },
  },
  { source = "stevearc/conform.nvim" },
  {
    source = "tpope/vim-dadbod",
    depends = { "kristijanhusak/vim-dadbod-ui" },
  },
  { source = "mfussenegger/nvim-lint" },
  { source = "neovim/nvim-lspconfig" },
  {
    source = "williamboman/mason.nvim",
    depends = {
      "williamboman/mason-lspconfig.nvim",
    },
  },
  { source = "WhoIsSethDaniel/mason-tool-installer.nvim" },
  { source = "folke/lazydev.nvim" },
  {
    source = "nvim-treesitter/nvim-treesitter",
    hooks = {
      post_checkout = function()
        vim.cmd "TSUpdate"
      end,
    },
  },
  { source = "nvim-treesitter/nvim-treesitter-context" },
  {
    source = "catppuccin/nvim",
    name = "catppuccin",
  },
  { source = "MeanderingProgrammer/render-markdown.nvim" },
  { source = "olivercederborg/poimandres.nvim" },
  { source = "b0o/SchemaStore.nvim" },
}
