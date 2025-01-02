package.path = package.path .. ";/Users/ray/.config/nvim/config/?.lua;/Users/ray-d-song/.config/nvim/config/?.lua"

require("lazy_config")

vim.cmd[[colorscheme tokyonight-night]]

vim.opt.termguicolors = true

vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth=2

vim.opt.nu = true

vim.o.clipboard = "unnamedplus"
vim.o.scrolloff = 10
vim.g.mapleader = ' '

vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'wq', ':wq<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'sa', ':w<CR>', { noremap = true, silent = true })

-- file tree
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeOpen<CR>', { noremap = true, silent = true })

-- terminal config
function OpenTerminal()
  vim.cmd('botright split')
  vim.cmd('resize 10')
  vim.cmd('terminal')
end
vim.api.nvim_create_user_command('Term', OpenTerminal, {})
vim.api.nvim_set_keymap('n', '<leader>t', ':Term<CR>', { noremap = true, silent = true })

-- ace jump
vim.api.nvim_set_keymap('n', '<leader><leader>j', ':HopWord<CR>', { noremap = true, silent = true })

-- reload config
vim.api.nvim_set_keymap('n', '<leader><leader>r', ':luafile $MYVIMRC<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>wh', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wl', '<C-w>l', { noremap = true, silent = true })
