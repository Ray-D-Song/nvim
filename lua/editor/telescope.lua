return {
  'echasnovski/mini.pick',
  config = function()
    require('mini.pick').setup({
      mappings = {
        caret_left = '<C-h>',
        caret_right = '<C-l>',
        choose = '<CR>',
        choose_in_split = '<C-s>',
        choose_in_tabpage = '<C-t>',
        choose_in_vsplit = '<C-v>',
        choose_marked = '<M-CR>',
        delete_char = '<BS>',
        delete_char_right = '<Del>',
        delete_left = '<C-u>',
        delete_word = '<C-w>',
        mark = '<C-x>',
        mark_all = '<C-a>',
        move_down = '<C-n>',
        move_start = '<C-g>',
        move_up = '<C-p>',
        paste = '<C-r>',
        refine = '<C-Space>',
        scroll_down = '<C-f>',
        scroll_left = '<C-H>',
        scroll_right = '<C-L>',
        scroll_up = '<C-b>',
        stop = '<Esc>',
        toggle_info = '<S-Tab>',
        toggle_preview = '<Tab>',
      },
    })
    
    -- 自定义高亮颜色，让选择更明显
    vim.api.nvim_set_hl(0, 'MiniPickMatchCurrent', { bg = '#3e4451', fg = '#61afef', bold = true })
    vim.api.nvim_set_hl(0, 'MiniPickMatchMarked', { bg = '#e06c75', fg = '#ffffff', bold = true })
    vim.api.nvim_set_hl(0, 'MiniPickBorderText', { fg = '#98c379' })
    vim.api.nvim_set_hl(0, 'MiniPickPrompt', { fg = '#e5c07b', bold = true })
    
    -- 设置键位映射
    vim.keymap.set('n', '<leader>ff', function() 
      require('mini.pick').builtin.files() 
    end, { desc = 'Find files' })
    
    vim.keymap.set('n', '<leader>fg', function() 
      require('mini.pick').builtin.grep_live() 
    end, { desc = 'Live grep' })
    
    vim.keymap.set('n', '<D-S-f>', function() 
      require('mini.pick').builtin.grep_live() 
    end, { desc = 'Live grep' })
    
    vim.keymap.set('n', '<leader>fb', function() 
      require('mini.pick').builtin.buffers() 
    end, { desc = 'Find buffers' })
    
    vim.keymap.set('n', '<leader>fh', function() 
      require('mini.pick').builtin.help() 
    end, { desc = 'Help tags' })
    
    vim.keymap.set('n', '<space>f', function() 
      require('mini.pick').builtin.files() 
    end, { desc = 'Find files' })
  end
}
