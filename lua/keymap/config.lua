-- insert mode
vim.keymap.set('i', 'jj', '<Esc>')  -- use jj to exit insert mode

-- Command mode keymap configuration
vim.keymap.set('n', 'sa', ':w<CR>')        -- Save file
vim.keymap.set('n', 'wq', ':wq<CR>')       -- Save and close file
vim.keymap.set('n', 'qf', ':lua vim.lsp.buf.code_action()<CR>')      -- Show LSP quick fix suggestions
vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')       -- Go to definition
vim.keymap.set('n', 'gr', ':lua vim.lsp.buf.references()<CR>')       -- View references
vim.keymap.set('n', 'K', ':lua vim.lsp.buf.hover()<CR>')             -- Show hover information
vim.keymap.set('n', '<space>K', function()
  -- Get hover information and copy to clipboard
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/hover', params, function(err, result, ctx, config)
    if result and result.contents then
      local content = ''
      if type(result.contents) == 'string' then
        content = result.contents
      elseif result.contents.value then
        content = result.contents.value
      elseif type(result.contents) == 'table' then
        for _, item in ipairs(result.contents) do
          if type(item) == 'string' then
            content = content .. item .. '\n'
          elseif item.value then
            content = content .. item.value .. '\n'
          end
        end
      end
      if content ~= '' then
        vim.fn.setreg('+', content)
        print('Hover content copied to clipboard')
      else
        print('No hover content available')
      end
    else
      print('No hover information available')
    end
  end)
end, { desc = 'Copy hover content to clipboard' })
vim.keymap.set('n', 'gs', ':lua require("mini.pick").builtin.grep_live()<CR>')              -- Use mini.pick for global search
vim.keymap.set('n', '<D-S-f>', ':lua require("mini.pick").builtin.grep_live()<CR>')        -- Use Command+Shift+F for global search
vim.keymap.set('n', 'cs', ':lua require("mini.pick").builtin.grep()<CR>') -- Use mini.pick to search in current file
vim.keymap.set('n', '<space>f', ':lua require("mini.pick").builtin.files()<CR>')      -- Use mini.pick to find files by name
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

-- Tab switching keymap (barbar plugin)
vim.keymap.set('n', 'th', ':BufferPrevious<CR>')   -- Switch to previous buffer
vim.keymap.set('n', 'tl', ':BufferNext<CR>')       -- Switch to next buffer

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
  vim.cmd('botright vsplit')
  vim.cmd('vertical resize 50')
  vim.cmd('terminal')
end
vim.api.nvim_create_user_command('Term', OpenTerminal, {})
vim.keymap.set('n', '<leader>t', ':Term<CR>')
-- 简化终端退出键位映射
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Diagnostic keymaps
vim.keymap.set('n', '<space>e', ':lua vim.diagnostic.open_float()<CR>')  -- Show diagnostic in float window
vim.keymap.set('n', '[d', ':lua vim.diagnostic.goto_prev()<CR>')         -- Go to previous diagnostic
vim.keymap.set('n', ']d', ':lua vim.diagnostic.goto_next()<CR>')         -- Go to next diagnostic
vim.keymap.set('n', '<space>q', ':lua vim.diagnostic.setloclist()<CR>')  -- Show diagnostic list

-- Copy diagnostic content to clipboard
vim.keymap.set('n', '<space>c', function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  if #diagnostics > 0 then
    local messages = {}
    for _, diagnostic in ipairs(diagnostics) do
      table.insert(messages, diagnostic.message)
    end
    local content = table.concat(messages, '\n')
    vim.fn.setreg('+', content)
    print('Diagnostic copied to clipboard')
  else
    print('No diagnostic at cursor')
  end
end, { desc = 'Copy diagnostic to clipboard' })

-- Diagnostic configuration
vim.diagnostic.config({
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

-- Auto show diagnostic on cursor hold
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end
})
