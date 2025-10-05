return {
  "rmagatti/auto-session",
  lazy = false,

  init = function()
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_restore_lazy_delay_enabled = true,
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    cwd_change_handling = {
      restore_upcoming_session = false,
    },
    -- log_level = 'debug',
    session_lens = {
      load_on_setup = true,
    },
    post_restore_cmds = {
      function()
        local nvim_tree_api = require('nvim-tree.api')
        if nvim_tree_api.tree.is_visible() then
          nvim_tree_api.tree.toggle()
        end
        nvim_tree_api.tree.toggle()
      end
    },
  },
}
