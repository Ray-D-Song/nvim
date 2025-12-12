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

vim.opt.autoread = false

-- Disabled auto-reloading configuration files
-- vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
--   pattern = "*",
--   command = "if mode() != 'c' | checktime | endif",
-- })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})

require("lazy").setup({
  spec = {
    {
      import = 'style',
    },
    {
      import = 'lsp.config',
    },
    {
      import = 'editor.fzf'
    },
    {
      import = 'editor.auto-session'
    },
    {
      "mg979/vim-visual-multi",
      branch = "master",
      init = function()
      end
    },
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("nvim-tree").setup {
          sync_root_with_cwd = true,
          respect_buf_cwd = true,
          update_focused_file = {
            enable = true,
            update_root = false,
          },
          view = {
            width = 40,
            preserve_window_proportions = true,
          },
        }
      end,
    },
    {
      "ray-d-song/calm.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        require("calm").setup({
        })

        vim.cmd.colorscheme("calm")
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
  checker = { enabled = false },
})

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

