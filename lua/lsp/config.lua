local gopls_config_fn = require('lsp.go')
local jsts_config_fn = require('lsp.js-ts')

-- Customize inlay hint display for TypeScript
local function setup_inlay_hint_customization()
  local methods = vim.lsp.protocol.Methods

  -- 可配置参数
  local MAX_LABEL_LEN = 30
  local ELLIPSIS = "…"
  local TARGET_CLIENTS = {
    ["typescript-tools"] = true,
    ["tsserver"] = true,
    ["ts_ls"] = true,  -- 添加 ts_ls 支持
  }

  -- 保留原 handler
  local original_handler = vim.lsp.handlers[methods.textDocument_inlayHint]

  -- 工具：截断字符串
  local function truncate(str, max_len)
    if #str <= max_len then
      return str
    end
    return str:sub(1, max_len - #ELLIPSIS) .. ELLIPSIS
  end

  -- 工具：处理 label（string | InlayHintLabelPart[]）
  local function normalize_label(label)
    if type(label) == "string" then
      return truncate(label, MAX_LABEL_LEN)
    end

    -- labelParts: { { value = "...", tooltip = ... }, ... }
    if type(label) == "table" then
      local buf = {}
      local total = 0

      for _, part in ipairs(label) do
        if type(part.value) ~= "string" then
          goto continue
        end

        local remain = MAX_LABEL_LEN - total
        if remain <= 0 then
          break
        end

        local value = part.value
        if #value > remain then
          value = truncate(value, remain)
          table.insert(buf, {
            value = value,
            tooltip = part.tooltip,
          })
          break
        end

        total = total + #value
        table.insert(buf, part)

        ::continue::
      end

      -- 超出时追加省略号
      if total >= MAX_LABEL_LEN then
        table.insert(buf, { value = ELLIPSIS })
      end

      return buf
    end

    return label
  end

  -- 覆盖 handler
  vim.lsp.handlers[methods.textDocument_inlayHint] = function(err, result, ctx, config)
    if err or type(result) ~= "table" then
      return original_handler(err, result, ctx, config)
    end

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client or not TARGET_CLIENTS[client.name] then
      return original_handler(err, result, ctx, config)
    end

    -- 映射为 table，避免 iterator 兼容问题
    local new_result = vim.tbl_map(function(hint)
      if hint.label ~= nil then
        hint.label = normalize_label(hint.label)
      end
      return hint
    end, result)

    return original_handler(err, new_result, ctx, config)
  end
end

-- 立即设置 inlay hint 自定义
setup_inlay_hint_customization()

-- Track if we were in a quickfix window
local was_in_qf = false

-- Auto-close quickfix/location list when jumping from it to a normal buffer
vim.api.nvim_create_autocmd('WinLeave', {
  callback = function()
    local current_buf = vim.api.nvim_get_current_buf()
    local buftype = vim.api.nvim_buf_get_option(current_buf, 'buftype')
    was_in_qf = (buftype == 'quickfix')
  end
})

vim.api.nvim_create_autocmd('WinEnter', {
  callback = function()
    if was_in_qf then
      local current_buf = vim.api.nvim_get_current_buf()
      local buftype = vim.api.nvim_buf_get_option(current_buf, 'buftype')
      -- If we just left a quickfix window and entered a normal buffer, close quickfix
      if buftype == '' then
        vim.defer_fn(function()
          vim.cmd('cclose')
          vim.cmd('lclose')
        end, 50)
      end
      was_in_qf = false
    end
  end
})

return {
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
        ensure_installed = {
          'java-debug-adapter',
          'java-test',
          'google-java-format',
          'vscode-java-dependency',
          'vscode-java-decompiler'
        }
      })
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'nvim-java/nvim-java'
    },
    config = function()
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

      -- Setup mason-lspconfig to ensure LSP servers are installed
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls', 'clangd', 'pyright', 'rust_analyzer',
          'eslint', 'ts_ls', 'intelephense',
          'gopls'
        },
      })

      -- Configure TypeScript LSP for JSX/TSX
      vim.lsp.config('ts_ls', {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
        settings = {
          typescript = {
            preferences = {
              includeCompletionsForModuleExports = true,
              includeCompletionsWithInsertText = true,
            },
          },
          javascript = {
            preferences = {
              includeCompletionsForModuleExports = true,
              includeCompletionsWithInsertText = true,
            },
          },
        },
      })

      -- Configure LSP servers using vim.lsp.config (new API)
      local servers = {
        'lua_ls', 'clangd', 'pyright', 'rust_analyzer',
        'eslint', 'intelephense', 'tailwindcss-language-server', 'ts_ls'
      }

      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
        vim.lsp.config(server, {
          capabilities = capabilities,
          on_attach = on_attach,
        })
      end

      -- Go with custom configuration
      gopls_config_fn(capabilities, on_attach)
      jsts_config_fn(capabilities, on_attach)
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
