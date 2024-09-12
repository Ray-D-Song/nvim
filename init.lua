package.path = package.path .. ";/Users/ray/.config/nvim/config/?.lua"

require("lazy_config")

vim.cmd[[colorscheme tokyonight-night]]

vim.opt.termguicolors = true

vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth=2

vim.opt.nu = true

