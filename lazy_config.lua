-- Bootstrap lazy.nvim
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazy_path) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazy_path })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazy_path)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "sbdchd/neoformat",
    },
    {
      'deparr/tairiki.nvim',
      lazy = false,
      priority = 1000, -- only necessary if you use tairiki as default theme
      config = function()
        require('tairiki').setup {
          -- optional configuration here
        }
        require('tairiki').load() -- only necessary to use as default theme, has same behavior as ':colorscheme tairiki'
      end,
    },
    {
      'romgrk/barbar.nvim',
      dependencies = {
        'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
        'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
      },
      init = function() vim.g.barbar_auto_setup = false end,
      opts = {
      },
      version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },
    {
      'ray-d-song/nvim-plugin-prompt-keymap',
      lazy = false,
      config = function()
      end,
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("nvim-tree").setup {}
      end,
    },
    -- {
    --     "dundalek/lazy-lsp.nvim",
    --     dependencies = {
    --       "neovim/nvim-lspconfig",
    --       {"VonHeikemen/lsp-zero.nvim", branch = "v3.x"},
    --       "hrsh7th/cmp-nvim-lsp",
    --       "hrsh7th/nvim-cmp",
    --     },
    --     config = function()
    --       local lsp_zero = require("lsp-zero")
      
    --       lsp_zero.on_attach(function(client, bufnr)
    --         -- see :help lsp-zero-keybindings to learn the available actions
    --         lsp_zero.default_keymaps({
    --           buffer = bufnr,
    --           preserve_mappings = false
    --         })
    --       end)
      
    --       require("lazy-lsp").setup {
    --         configs = {
    --           lua_ls = {
    --              settings = {
    --                Lua = {
    --                  diagnostics = {
    --                    -- Get the language server to recognize the `vim` global
    --                    globals = { "vim" },
    --                  },
    --                },
    --              },
    --            },
    --         },
    --       }
    --     end,
    --   },
    --   {
    --     "hrsh7th/nvim-cmp",
    --     -- load cmp on InsertEnter
    --     event = "InsertEnter",
    --     -- these dependencies will only be loaded when cmp loads
    --     -- dependencies are always lazy-loaded unless specified otherwise
    --     dependencies = {
    --       "hrsh7th/cmp-nvim-lsp",
    --       "hrsh7th/cmp-buffer",
    --     },
    --     config = function()
    --       local cmp = require('cmp')
    --       cmp.setup({
    --         preselect = 'item',
    --         completion = {
    --           completeopt = 'menu,menuone,noinsert'
    --         },
    --         mapping = cmp.mapping.preset.insert({
    --           ['<CR>'] = cmp.mapping.confirm({select = false}),
    --         }),
    --       })
    --     end,
    --   },
    {
      'smoka7/hop.nvim',
      version = "*",
      opts = {
          keys = 'etovxqpdygfblzhckisuran'
      }
    }
  },
  checker = { enabled = true },
})
