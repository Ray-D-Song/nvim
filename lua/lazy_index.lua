-- 安装 lazy.nvim
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazy_path) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazy_path })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazy_path)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 设置 lazy.nvim
require("lazy").setup({
  spec = {
    -- 加载样式配置
    {
      import = 'style.config',
    },
    -- 加载 lsp 配置
    {
      import = 'lsp.config',
    },
    -- 其他配置
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
    {
      'deparr/tairiki.nvim',
      lazy = false,
      priority = 1000,
      config = function()
        require('tairiki').setup {
        }
        require('tairiki').load()
      end,
    },
    {
      'smoka7/hop.nvim',
      version = "*",
      opts = {
        keys = 'etovxqpdygfblzhckisuran'
      }
    },
  },
  checker = { enabled = true },
})
