package.path = package.path .. ";/Users/ray/.config/nvim/?.lua;/Users/ray-d-song/.config/nvim/?.lua"

require('lazy_config')

-- insert mode
vim.keymap.set('i', 'jj', '<Esc>')  -- use jj to exit insert mode

-- Command mode keymap configuration
if vim.g.vscode then
  -- VSCode specific configuration
  vim.keymap.set('n', 'sa', '<Cmd>call VSCodeCall("workbench.action.files.save")<CR>')          -- Save file
  vim.keymap.set('n', 'wq', '<Cmd>call VSCodeCall("workbench.action.files.save")<CR><Cmd>call VSCodeCall("workbench.action.closeActiveEditor")<CR>')  -- Save and close file
  vim.keymap.set('n', 'qf', '<Cmd>call VSCodeCall("editor.action.quickFix")<CR>')              -- Show quick fix suggestions
  vim.keymap.set('n', 'gd', '<Cmd>call VSCodeCall("editor.action.revealDefinition")<CR>')      -- Go to definition
  vim.keymap.set('n', 'gr', '<Cmd>call VSCodeCall("editor.action.goToReferences")<CR>')        -- View references
  vim.keymap.set('n', 'gs', '<Cmd>call VSCodeCall("workbench.action.findInFiles")<CR>')        -- Global search
  vim.keymap.set('n', 'cs', '<Cmd>call VSCodeCall("actions.find")<CR>')                        -- Search in current file
  vim.keymap.set('n', 'x', '<Cmd>call VSCodeCall("workbench.action.closeActiveEditor")<CR>')   -- Close current file

  -- Split screen operation keymap
  vim.keymap.set('n', '<space>sx', '<Cmd>call VSCodeCall("workbench.action.splitEditorDown")<CR>')    -- Split screen horizontally
  vim.keymap.set('n', '<space>sy', '<Cmd>call VSCodeCall("workbench.action.splitEditorRight")<CR>')   -- Split screen vertically
  vim.keymap.set('n', '<space>sc', '<Cmd>call VSCodeCall("workbench.action.closeActiveEditor")<CR>')  -- Close current split screen

  -- Window switching keymap
  vim.keymap.set('n', '<space>sh', '<Cmd>call VSCodeCall("workbench.action.focusLeftGroup")<CR>')     -- Switch to left window
  vim.keymap.set('n', '<space>sl', '<Cmd>call VSCodeCall("workbench.action.focusRightGroup")<CR>')    -- Switch to right window
  vim.keymap.set('n', '<space>sk', '<Cmd>call VSCodeCall("workbench.action.focusAboveGroup")<CR>')    -- Switch to top window
  vim.keymap.set('n', '<space>sj', '<Cmd>call VSCodeCall("workbench.action.focusBelowGroup")<CR>')    -- Switch to bottom window
else
  -- NeoVim native configuration
  vim.keymap.set('n', 'sa', ':w<CR>')        -- Save file
  vim.keymap.set('n', 'wq', ':wq<CR>')       -- Save and close file
  vim.keymap.set('n', 'qf', ':lua vim.lsp.buf.code_action()<CR>')      -- Show LSP quick fix suggestions
  vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')       -- Go to definition
  vim.keymap.set('n', 'gr', ':lua vim.lsp.buf.references()<CR>')       -- View references
  vim.keymap.set('n', 'gs', ':lua require("telescope.builtin").live_grep()<CR>')              -- Use telescope for global search
  vim.keymap.set('n', 'cs', ':lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>') -- Use telescope to search in current file
  vim.keymap.set('n', 'x', ':q<CR>')         -- Close current file

  -- Split screen operation keymap
  vim.keymap.set('n', '<space>sx', ':split<CR>')   -- Split screen horizontally
  vim.keymap.set('n', '<space>sy', ':vsplit<CR>')  -- Split screen vertically
  vim.keymap.set('n', '<space>sc', ':close<CR>')   -- Close current split screen
  
  -- Window switching keymap
  vim.keymap.set('n', '<space>sh', '<C-w>h')  -- Switch to left window
  vim.keymap.set('n', '<space>sl', '<C-w>l')  -- Switch to right window
  vim.keymap.set('n', '<space>sk', '<C-w>k')  -- Switch to top window
  vim.keymap.set('n', '<space>sj', '<C-w>j')  -- Switch to bottom window
end

-- Movement related keymap configuration
vim.keymap.set('n', '<space>k', '10k')  -- Move up 10 lines
vim.keymap.set('n', '<space>j', '10j')  -- Move down 10 lines
vim.keymap.set('n', '<space>h', '10h')  -- Move left 10 characters
vim.keymap.set('n', '<space>l', '10l')  -- Move right 10 characters

-- Quick movement keymap (using Hop)
vim.keymap.set('n', '<space<space>k', ':HopLineStartBC<CR>')  -- Move up
vim.keymap.set('n', '<space<space>j', ':HopLineStartAC<CR>')  -- Move down
vim.keymap.set('n', '<space<space>h', ':HopWordBC<CR>')  -- Move left 20 characters
vim.keymap.set('n', '<space<space>l', ':HopWordAC<CR>')  -- Move right 20 characters

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
