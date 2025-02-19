vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("pde_vtsls", { clear = true }),
  pattern = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  callback = function(args)
    vim.keymap.set("n", "gD", function()
      ---@diagnostic disable-next-line: missing-parameter
      local params = vim.lsp.util.make_position_params()
      PDE.util.execute {
        command = "typescript.goToSourceDefinition",
        arguments = { params.textDocument.uri, params.position },
        open = true,
      }
    end, { desc = "Goto Source Definition", buffer = args.buf })

    vim.keymap.set(
      "n",
      "gR",
      function()
        PDE.util.execute {
          command = "typescript.findAllFileReferences",
          arguments = { vim.uri_from_bufnr(0) },
          open = true,
        }
      end,
      { desc = "File References", buffer = args.buf }
    )
  end,
})

-- {
--   "<leader>co",
--   LazyVim.lsp.action["source.organizeImports"],
--   desc = "Organize Imports",
-- },
-- {
--   "<leader>cM",
--   LazyVim.lsp.action["source.addMissingImports.ts"],
--   desc = "Add missing imports",
-- },
-- {
--   "<leader>cu",
--   LazyVim.lsp.action["source.removeUnused.ts"],
--   desc = "Remove unused imports",
-- },
-- {
--   "<leader>cD",
--   LazyVim.lsp.action["source.fixAll.ts"],
--   desc = "Fix all diagnostics",
-- },

return {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    javascript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = {
        completeFunctionCalls = true,
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = {
        completeFunctionCalls = true,
      },
    },
  },
}
