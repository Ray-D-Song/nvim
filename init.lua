package.path = package.path .. ";/Users/ray/.config/nvim/?.lua;/Users/ray-d-song/.config/nvim/?.lua"

require('lazy_config')

-- 命令模式键位配置
if vim.g.vscode then
  -- VSCode 特定配置
  vim.keymap.set('n', 'sa', '<Cmd>call VSCodeCall("workbench.action.files.save")<CR><Cmd>call VSCodeCall("editor.action.formatDocument")<CR>')          -- 保存文件并格式化
  vim.keymap.set('n', 'wq', '<Cmd>call VSCodeCall("workbench.action.files.save")<CR><Cmd>call VSCodeCall("workbench.action.closeActiveEditor")<CR>')  -- 保存并关闭文件
  vim.keymap.set('n', 'qf', '<Cmd>call VSCodeCall("editor.action.quickFix")<CR>')              -- 显示快速修复建议
  vim.keymap.set('n', 'gd', '<Cmd>call VSCodeCall("editor.action.revealDefinition")<CR>')      -- 跳转到定义
  vim.keymap.set('n', 'gr', '<Cmd>call VSCodeCall("editor.action.goToReferences")<CR>')        -- 查看引用
  vim.keymap.set('n', 'gs', '<Cmd>call VSCodeCall("workbench.action.findInFiles")<CR>')        -- 全局搜索
  vim.keymap.set('n', 'cs', '<Cmd>call VSCodeCall("actions.find")<CR>')                        -- 当前文件内搜索
  vim.keymap.set('n', 'x', '<Cmd>call VSCodeCall("workbench.action.closeActiveEditor")<CR>')   -- 关闭当前文件件

  -- 分屏操作键位
  vim.keymap.set('n', '<space>sx', '<Cmd>call VSCodeCall("workbench.action.splitEditorDown")<CR>')    -- 水平分屏
  vim.keymap.set('n', '<space>sy', '<Cmd>call VSCodeCall("workbench.action.splitEditorRight")<CR>')   -- 垂直分屏
  vim.keymap.set('n', '<space>sc', '<Cmd>call VSCodeCall("workbench.action.closeActiveEditor")<CR>')  -- 关闭当前分屏

  -- 窗口切换键位
  vim.keymap.set('n', '<space>sh', '<Cmd>call VSCodeCall("workbench.action.focusLeftGroup")<CR>')     -- 切换到左边窗口
  vim.keymap.set('n', '<space>sl', '<Cmd>call VSCodeCall("workbench.action.focusRightGroup")<CR>')    -- 切换到右边窗口
  vim.keymap.set('n', '<space>sk', '<Cmd>call VSCodeCall("workbench.action.focusAboveGroup")<CR>')    -- 切换到上边窗口
  vim.keymap.set('n', '<space>sj', '<Cmd>call VSCodeCall("workbench.action.focusBelowGroup")<CR>')    -- 切换到下边窗口
else
  -- NeoVim 原生配置
  vim.keymap.set('n', 'sa', ':w<CR>')        -- 保存文件
  vim.keymap.set('n', 'wq', ':wq<CR>')       -- 保存并关闭文件
  vim.keymap.set('n', 'qf', ':lua vim.lsp.buf.code_action()<CR>')      -- 显示 LSP 快速修复建议
  vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')       -- 跳转到定义
  vim.keymap.set('n', 'gr', ':lua vim.lsp.buf.references()<CR>')       -- 查看引用
  vim.keymap.set('n', 'gs', ':lua require("telescope.builtin").live_grep()<CR>')              -- 使用 telescope 进行全局搜索
  vim.keymap.set('n', 'cs', ':lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>') -- 使用 telescope 在当前文件中搜索
  vim.keymap.set('n', 'x', ':q<CR>')         -- 关闭当前文件

  -- 分屏操作键位
  vim.keymap.set('n', '<space>sx', ':split<CR>')   -- 水平分屏
  vim.keymap.set('n', '<space>sy', ':vsplit<CR>')  -- 垂直分屏
  vim.keymap.set('n', '<space>sc', ':close<CR>')   -- 关闭当前分屏
  
  -- 窗口切换键位
  vim.keymap.set('n', '<space>sh', '<C-w>h')  -- 切换到左边窗口
  vim.keymap.set('n', '<space>sl', '<C-w>l')  -- 切换到右边窗口
  vim.keymap.set('n', '<space>sk', '<C-w>k')  -- 切换到上边窗口
  vim.keymap.set('n', '<space>sj', '<C-w>j')  -- 切换到下边窗口
end

-- 移动相关键位配置
vim.keymap.set('n', '<space>k', '10k')  -- 向上移动 10 行
vim.keymap.set('n', '<space>j', '10j')  -- 向下移动 10 行
vim.keymap.set('n', '<space>h', '10h')  -- 向左移动 10 个字符
vim.keymap.set('n', '<space>l', '10l')  -- 向右移动 10 个字符

-- 快速移动键位（使用 Hop）
vim.keymap.set('n', '<space><space>k', ':HopLineStartBC<CR>')  -- 向上移动
vim.keymap.set('n', '<space><space>j', ':HopLineStartAC<CR>')  -- 向下移动
vim.keymap.set('n', '<space><space>h', ':HopWordBC<CR>')  -- 向左移动
vim.keymap.set('n', '<space><space>l', ':HopWordAC<CR>')  -- 向右移动

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
