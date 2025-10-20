return function(capabilities, on_attach)
  -- Get vue-language-server path from Mason
  local vue_language_server_path = vim.fn.stdpath('data') .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'

  -- Define TypeScript filetypes to include Vue
  local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }

  -- Configure Vue plugin for TypeScript server
  local vue_plugin = {
    name = '@vue/typescript-plugin',
    location = vue_language_server_path,
    languages = { 'vue' },
    configNamespace = 'typescript',
  }

  -- Update ts_ls configuration to include Vue plugin
  vim.lsp.config('ts_ls', {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      -- Disable semantic tokens for Vue files (let vue_ls handle it)
      if vim.bo.filetype == 'vue' then
        client.server_capabilities.semanticTokensProvider = false
      end
      on_attach(client, bufnr)
    end,
    init_options = {
      plugins = {
        vue_plugin,
      },
    },
    filetypes = tsserver_filetypes,
    settings = {
      implicitProjectConfiguration = {
        checkJs = true
      },
    }
  })

  -- Configure vue_ls
  vim.lsp.config('vue_ls', {
    capabilities = capabilities,
    on_attach = on_attach,
    on_init = function(client)
      client.handlers['tsserver/request'] = function(_, result, context)
        local ts_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'ts_ls' })

        if #ts_clients == 0 then
          vim.notify('Could not find `ts_ls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
          return
        end

        local ts_client = ts_clients[1]
        local param = unpack(result)
        local id, command, payload = unpack(param)

        ts_client:exec_cmd({
          title = 'vue_request_forward',
          command = 'typescript.tsserverRequest',
          arguments = {
            command,
            payload,
          },
        }, { bufnr = context.bufnr }, function(_, r)
          local response = r and r.body
          local response_data = { { id, response } }
          client:notify('tsserver/response', response_data)
        end)
      end
    end,
  })

  -- Enable both servers
  vim.lsp.enable({'ts_ls', 'vue_ls'})

  -- Set up custom component highlighting
  vim.api.nvim_set_hl(0, '@lsp.type.component', { link = '@type' })
end
