-- Insert mode
vim.keymap.set('i', 'jj', '<Esc>') -- Use jj to exit insert mode


-- Command mode keymap configuration
vim.keymap.set({ 'n', 'v' }, '<D-/>', 'gcc', { remap = true })       -- Toggle comment
vim.keymap.set('n', 'ca', 'ggVG', { noremap = true, silent = true }) -- Select all content
-- Format code
vim.keymap.set('n', 'fmt', function()
  vim.lsp.buf.format { async = true }
end, opts)

vim.keymap.set('n', 'sa', ':w<CR>')                             -- Save file
vim.keymap.set('n', 'wq', ':wq<CR>')                            -- Save and close file
vim.keymap.set('n', 'qf', ':lua vim.lsp.buf.code_action()<CR>') -- Show LSP quick fix suggestions
vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')  -- Go to definition
vim.keymap.set('n', 'sd', function()
  -- Get current position
  local params = vim.lsp.util.make_position_params()

  -- Request definition and show in floating window
  vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result, ctx, config)
    if err or not result or #result == 0 then
      print('No definition found')
      return
    end

    -- Get the first result
    local definition = result[1]

    -- Get file content
    local uri = definition.uri or definition.targetUri
    local range = definition.range or definition.targetRange
    local filename = vim.uri_to_fname(uri)

    -- Read the file
    local lines = {}
    local file = io.open(filename, 'r')
    if file then
      for line in file:lines() do
        table.insert(lines, line)
      end
      file:close()
    end

    -- Extract function definition (get some context around the definition)
    local start_line = math.max(1, range.start.line - 5)
    local end_line = math.min(#lines, range['end'].line + 10)

    local content = {}
    for i = start_line, end_line do
      local line_content = lines[i] or ''
      if i == range.start.line + 1 then
        line_content = line_content .. ' ← Definition'
      end
      table.insert(content, string.format('%3d %s', i, line_content))
    end

    -- Create floating window
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'filetype', vim.bo.filetype)

    -- Calculate window size
    local width = math.min(80, vim.o.columns - 10)
    local height = math.min(20, #content)

    -- Get cursor position for window placement
    local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
    local win_height = vim.api.nvim_win_get_height(0)
    local row = math.min(cursor_row + 1, win_height - height - 2)

    -- Create floating window
    local win = vim.api.nvim_open_win(buf, false, {
      relative = 'win',
      win = 0,
      row = row,
      col = 2,
      width = width,
      height = height,
      border = 'rounded',
      style = 'minimal',
      focusable = true,
      zindex = 50,
    })

    -- Set window options
    vim.api.nvim_win_set_option(win, 'winhl', 'Normal:Normal,FloatBorder:DiagnosticInfo')
    vim.api.nvim_win_set_option(win, 'signcolumn', 'no')

    -- Add keymaps to close the window
    local close_win = function()
      vim.api.nvim_win_close(win, true)
    end

    vim.keymap.set('n', 'q', close_win, { buffer = buf, nowait = true })
    vim.keymap.set('n', '<Esc>', close_win, { buffer = buf, nowait = true })

    -- Close window when cursor moves
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'BufLeave' }, {
      buffer = 0,
      once = true,
      callback = close_win,
    })

    -- Close window when inserting text
    vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
      once = true,
      callback = close_win,
    })
  end)
end, { desc = 'Show definition in floating window' })
vim.keymap.set('n', 'gr', ':lua vim.lsp.buf.references()<CR>') -- View references
vim.keymap.set('n', 'K', ':lua vim.lsp.buf.hover()<CR>')       -- Show hover information
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
vim.keymap.set('n', 'gs', ':lua require("mini.pick").builtin.grep_live()<CR>')      -- Use mini.pick for global search
vim.keymap.set('n', '<D-S-f>', ':lua require("mini.pick").builtin.grep_live()<CR>') -- Use Command+Shift+F for global search
vim.keymap.set('n', 'cs', ':lua require("mini.pick").builtin.grep()<CR>')           -- Use mini.pick to search in current file
vim.keymap.set('n', '<space>f', ':lua require("mini.pick").builtin.files()<CR>')    -- Use mini.pick to find files by name
vim.keymap.set('n', 'x', ':q<CR>')                                                  -- Close current file

-- Split screen operation keymap
vim.keymap.set('n', 'wx', ':split<CR>')  -- Split screen horizontally
vim.keymap.set('n', 'wy', ':vsplit<CR>') -- Split screen vertically
vim.keymap.set('n', 'wc', ':close<CR>')  -- Close current split screen

-- Window switching keymap
vim.keymap.set('n', 'wh', '<C-w>h') -- Switch to left window
vim.keymap.set('n', 'wl', '<C-w>l') -- Switch to right window
vim.keymap.set('n', 'wk', '<C-w>k') -- Switch to top window
vim.keymap.set('n', 'wj', '<C-w>j') -- Switch to bottom window

-- Tab switching keymap (barbar plugin)
vim.keymap.set('n', 'th', ':BufferPrevious<CR>') -- Switch to previous buffer
vim.keymap.set('n', 'tl', ':BufferNext<CR>')     -- Switch to next buffer
vim.keymap.set('n', 'tx', ':BufferClose<CR>')    -- Close current buffer

-- Movement related keymap configuration
vim.keymap.set('n', '<space>k', '10k') -- Move up 10 lines
vim.keymap.set('n', '<space>j', '10j') -- Move down 10 lines
vim.keymap.set('n', '<space>h', '10h') -- Move left 10 characters
vim.keymap.set('n', '<space>l', '10l') -- Move right 10 characters

-- Quick movement keymap (using Hop)
vim.keymap.set('n', '<space><space>k', ':HopLineStartBC<CR>') -- Move up
vim.keymap.set('n', '<space><space>j', ':HopLineStartAC<CR>') -- Move down
vim.keymap.set('n', '<space><space>h', ':HopWordBC<CR>')      -- Move left 20 characters
vim.keymap.set('n', '<space><space>l', ':HopWordAC<CR>')      -- Move right 20 characters

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
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Diagnostic keymaps
vim.keymap.set('n', '<space>e', ':lua vim.diagnostic.open_float()<CR>') -- Show diagnostic in float window
vim.keymap.set('n', '[d', ':lua vim.diagnostic.goto_prev()<CR>')        -- Go to previous diagnostic
vim.keymap.set('n', ']d', ':lua vim.diagnostic.goto_next()<CR>')        -- Go to next diagnostic
vim.keymap.set('n', '<space>q', ':lua vim.diagnostic.setloclist()<CR>') -- Show diagnostic list

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
  virtual_text = true,  -- 显示行尾的错误/警告文本
  signs = true,         -- 显示行号旁的图标
  underline = true,     -- 在错误处显示下划线
  update_in_insert = false,  -- 插入模式下不更新诊断
  severity_sort = true,      -- 按严重程度排序
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
