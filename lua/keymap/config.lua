-- insert mode
vim.keymap.set('i', 'jj', '<Esc>')  -- use jj to exit insert mode

-- Command mode keymap configuration
vim.keymap.set('n', 'sa', ':w<CR>')        -- Save file
vim.keymap.set('n', 'wq', ':wq<CR>')       -- Save and close file
vim.keymap.set('n', 'qf', ':lua vim.lsp.buf.code_action()<CR>')      -- Show LSP quick fix suggestions
vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')       -- Go to definition
vim.keymap.set('n', 'gr', ':lua vim.lsp.buf.references()<CR>')       -- View references
vim.keymap.set('n', 'gs', ':lua require("telescope.builtin").live_grep()<CR>')              -- Use telescope for global search
vim.keymap.set('n', '<D-S-f>', ':lua require("telescope.builtin").live_grep()<CR>')        -- Use Command+Shift+F for global search
vim.keymap.set('n', 'cs', ':lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>') -- Use telescope to search in current file
vim.keymap.set('n', '<space>f', ':lua require("telescope.builtin").find_files()<CR>')      -- Use telescope to find files by name
vim.keymap.set('n', 'x', ':q<CR>')         -- Close current file

-- Split screen operation keymap
vim.keymap.set('n', 'wx', ':split<CR>')   -- Split screen horizontally
vim.keymap.set('n', 'wy', ':vsplit<CR>')  -- Split screen vertically
vim.keymap.set('n', 'wc', ':close<CR>')   -- Close current split screen

-- Window switching keymap
vim.keymap.set('n', 'wh', '<C-w>h')  -- Switch to left window
vim.keymap.set('n', 'wl', '<C-w>l')  -- Switch to right window
vim.keymap.set('n', 'wk', '<C-w>k')  -- Switch to top window
vim.keymap.set('n', 'wj', '<C-w>j')  -- Switch to bottom window

-- Tab switching keymap
vim.keymap.set('n', 'th', 'gT')   -- Switch to previous tab
vim.keymap.set('n', 'tl', 'gt')   -- Switch to next tab

-- Movement related keymap configuration
vim.keymap.set('n', '<space>k', '10k')  -- Move up 10 lines
vim.keymap.set('n', '<space>j', '10j')  -- Move down 10 lines
vim.keymap.set('n', '<space>h', '10h')  -- Move left 10 characters
vim.keymap.set('n', '<space>l', '10l')  -- Move right 10 characters

-- Quick movement keymap (using Hop)
vim.keymap.set('n', '<space><space>k', ':HopLineStartBC<CR>')  -- Move up
vim.keymap.set('n', '<space><space>j', ':HopLineStartAC<CR>')  -- Move down
vim.keymap.set('n', '<space><space>h', ':HopWordBC<CR>')  -- Move left 20 characters
vim.keymap.set('n', '<space><space>l', ':HopWordAC<CR>')  -- Move right 20 characters

vim.opt.termguicolors = true

vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2

vim.opt.nu = true

vim.o.clipboard = "unnamedplus"
vim.o.scrolloff = 10

-- terminal config
function OpenTerminal()
  vim.cmd('botright split')
  vim.cmd('resize 10')
  vim.cmd('terminal')
end
vim.api.nvim_create_user_command('Term', OpenTerminal, {})

-- Diagnostic keymaps
vim.keymap.set('n', '<space>e', ':lua vim.diagnostic.open_float()<CR>')  -- Show diagnostic in float window
vim.keymap.set('n', '[d', ':lua vim.diagnostic.goto_prev()<CR>')         -- Go to previous diagnostic
vim.keymap.set('n', ']d', ':lua vim.diagnostic.goto_next()<CR>')         -- Go to next diagnostic
vim.keymap.set('n', '<space>q', ':lua vim.diagnostic.setloclist()<CR>')  -- Show diagnostic list
