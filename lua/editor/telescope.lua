return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('fzf-lua').setup({
      winopts = {
        height = 0.85,
        width = 0.80,
        preview = {
          default = 'bat',
          border = 'border',
          wrap = 'nowrap',
          hidden = 'nohidden',
          vertical = 'down:45%',
          horizontal = 'right:60%',
          layout = 'flex',
        },
      },
    })

    local fzf = require('fzf-lua')

    -- 设置键位映射
    vim.keymap.set('n', '<leader><leader>f', fzf.live_grep, { desc = 'Live grep' })
    vim.keymap.set('n', '<leader>f', fzf.files, { desc = 'Find files' })
  end
}
