return function(lspconfig, capabilities, on_attach)
  lspconfig.gopls.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      -- 1. ensure keymap
      on_attach(client, bufnr)

      -- 2. format on save
      if client.supports_method('textDocument/formatting') then
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ async = false, bufnr = bufnr })
          end,
        })
      end
    end,
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          shadow       = true,
        },
        staticcheck = true,
      },
    },
  })
end
