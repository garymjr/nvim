vim.filetype.add {
  extension = {
    ex = "elixir",
  },
}

vim.treesitter.language.register("markdown", "livebook")

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("pde_elixirls", { clear = true }),
  pattern = { "elixir" },
  callback = function(args)
    vim.keymap.set("n", "<leader>cp", function()
      ---@diagnostic disable-next-line: missing-parameter
      local params = vim.lsp.util.make_position_params()
      PDE.util.execute {
        command = "manipulatePipes:serverid",
        arguments = {
          "toPipe",
          params.textDocument.uri,
          params.position.line,
          params.position.character,
        },
      }
    end, { desc = "To Pipe", buffer = args.buf })

    vim.keymap.set("n", "<leader>cP", function()
      ---@diagnostic disable-next-line: missing-parameter
      local params = vim.lsp.util.make_position_params()
      PDE.util.execute {
        command = "manipulatePipes:serverid",
        arguments = {
          "fromPipe",
          params.textDocument.uri,
          params.position.line,
          params.position.character,
        },
      }
    end, { desc = "From Pipe", buffer = args.buf })
  end,
})

return {}
