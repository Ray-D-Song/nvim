return {
  --  使用 mason 安装 lsp
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  -- LSP 配置
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local lspconfig = require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')
      
      -- 设置 LSP 服务器
      mason_lspconfig.setup({
        ensure_installed = {
          'lua_ls',
          'clangd',
          'pyright',
          'rust_analyzer',
        },
      })

      -- 设置 LSP 配置
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      mason_lspconfig.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,
      })
    end,
  },
  -- 使用 blink.nvim 进行补全
  {
    'saghen/blink.cmp',
    -- 可选: 提供 snippets 用于 snippet 源
    dependencies = { 'rafamadriz/friendly-snippets' },

    -- 使用一个发布标签来下载预构建的二进制文件
    version = '1.*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) 用于类似内置补全的映射 (C-y 用于接受)
      -- 'super-tab' 用于类似 vscode 的映射 (tab 用于接受)
      -- 'enter' 用于接受
      -- 'none' 用于没有映射
      --
      -- 所有预设都有以下映射:
      -- C-space: 打开菜单或打开文档(如果已打开)
      -- C-n/C-p 或 Up/Down: 选择下一个/上一个项目
      -- C-e: 隐藏菜单
      -- C-k: 切换签名帮助(如果 signature.enabled = true)
      --
      -- 查看 :h blink-cmp-config-keymap 定义自己的映射
      keymap = { preset = 'super-tab' },

      appearance = {
        -- 'mono' (默认) 用于 'Nerd Font Mono' 或 'normal' 用于 'Nerd Font'
        -- 调整间距以确保图标对齐
        nerd_font_variant = 'mono'
      },

      -- (默认) 仅在手动触发时显示文档弹出窗口
      completion = { documentation = { auto_show = true } },

      -- 默认启用的提供者列表, 以便你可以扩展它
      -- 在配置中, 无需重新定义它, 因为 `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      -- (默认) 用于拼写错误抵抗和显著更好性能的 Rust 模糊匹配器
      -- 你可以使用 `implementation = "lua"` 或回退到 lua 实现,
      -- 当 Rust 模糊匹配器不可用时, 使用 `implementation = "prefer_rust"`
      --
      -- 查看模糊匹配文档了解更多信息
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  }
}
