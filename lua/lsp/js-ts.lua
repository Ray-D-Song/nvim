return function(capabilities, on_attach)
  vim.lsp.enable('ts_ls')
  vim.lsp.config('ts_ls', {
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "literals",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayVariableTypeHints = false,
          includeInlayFunctionLikeReturnTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = false,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayVariableTypeHints = true,
        },
      },
    },
  })
end
