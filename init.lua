package.path = package.path .. ";/Users/ray/.config/nvim/config/?.lua;/Users/ray-d-song/.config/nvim/config/?.lua"

require("lazy_config")

vim.cmd[[colorscheme tokyonight-night]]

vim.opt.termguicolors = true

vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth=2

vim.opt.nu = true

vim.o.clipboard = "unnamedplus"
vim.g.mapleader = ' '

vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeOpen<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>t', ':edit term://zsh<CR>', { noremap = true, silent = true })
