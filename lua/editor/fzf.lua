return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('fzf-lua').setup({
      winopts = {
        height = 0.85,
        width = 0.80,
      },
    })

    local fzf = require('fzf-lua')

    vim.keymap.set('n', '<leader><leader>f', fzf.live_grep, { desc = 'Live grep' })
    vim.keymap.set('n', '<leader>f', fzf.files, { desc = 'Find files' })
  end
}
