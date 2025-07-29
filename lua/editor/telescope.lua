return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('telescope').setup({
      defaults = {
        vimgrep_arguments = {
          'grep',
          '-n',
          '-r',
          '--exclude-dir=.git',
          '--exclude-dir=node_modules',
          '--exclude-dir=.next',
          '--exclude-dir=dist',
          '--exclude-dir=build',
        },
        file_ignore_patterns = {
          "%.git/",
          "node_modules/",
          "%.next/",
          "dist/",
          "build/",
          "%.lock",
        },
      },
      pickers = {
        find_files = {
          find_command = { 'find', '.', '-type', 'f' },
        },
        live_grep = {
          additional_args = function()
            return {}
          end
        },
      },
    })
    
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set('n', '<D-S-f>', builtin.live_grep, {})
  end
}
