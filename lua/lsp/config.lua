local gopls_config_fn = require('lsp.go.config')

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter.configs').setup({
          ensure_installed = {
            'lua', 'vim', 'vimdoc', 'query',
            'javascript', 'typescript', 'tsx', 'json',
            'html', 'css', 'python', 'rust', 'c', 'cpp',
            'php', 'vue', 'markdown', 'go'
          },
          sync_install = false,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          indent = {
            enable = true
          },
        })
      end,
    },
    {
      'numToStr/Comment.nvim',
    },
    {
      'williamboman/mason.nvim',
      config = function()
        require('mason').setup()
      end,
    },
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      dependencies = { 'williamboman/mason.nvim' },
      config = function()
        require('mason-tool-installer').setup({
        })
      end,
    },
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
      },
      config = function()
        local lspconfig = require('lspconfig')
        local mason_lspconfig = require('mason-lspconfig')
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        -- Lsp key bindings
        local on_attach = function(client, bufnr)
          local opts = { noremap = true, silent = true, buffer = bufnr }
          -- Go definition
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          -- Go declaration
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          -- Go implementation
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          -- Show help
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          -- Show message
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          -- Rename
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          -- Code action
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          -- Find ref
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        end
        mason_lspconfig.setup({
          ensure_installed = {
            'lua_ls',
            'clangd',
            'pyright',
            'rust_analyzer',
            'eslint',
            'ts_ls',
            'vuels',
            'cmake',
            'intelephense',
            'phpactor',
            'gopls'
          },
          handlers = {
            function(server_name)
              lspconfig[server_name].setup({
                capabilities = capabilities,
                on_attach = on_attach,
              })
            end,
            -- TypeScript/JavaScript
            ts_ls = function()
              lspconfig.ts_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                  implicitProjectConfiguration = {
                    checkJs = true
                  },
                }
              })
            end,
            -- Go
            gopls = function()
              gopls_config_fn(lspconfig, capabilities, on_attach)
            end
          }
        })
      end,
    },
    {
      'mfussenegger/nvim-dap',
      dependencies = {
        'williamboman/mason.nvim',
        'jay-babu/mason-nvim-dap.nvim',
      },
      config = function()
        local mason_nvim_dap = require('mason-nvim-dap')
        mason_nvim_dap.setup({
          ensure_installed = {
            'js-debug-adapter',
            'python',
          },
          handlers = {},
        })
      end,
    },
    {
      'saghen/blink.cmp',
      dependencies = { 'rafamadriz/friendly-snippets' },

      version = '1.*',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        keymap = { preset = 'super-tab' },

        appearance = {
          nerd_font_variant = 'mono'
        },

        completion = {
          documentation = { auto_show = true },
          menu = { max_height = 5 }
        },

        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    },
    {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      config = function()
        require('nvim-autopairs').setup({
          check_ts = true,
          ts_config = {
            lua = { 'string' },
            javascript = { 'string', 'template_string' },
          },
          disable_filetype = { "TelescopePrompt", "vim" },
        })
      end
    }
}
