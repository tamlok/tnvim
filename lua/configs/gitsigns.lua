local M = {}

function M.config()
  local status_ok, gitsigns = pcall(require, "gitsigns")
  if status_ok then
    gitsigns.setup(require("core.utils").user_plugin_opts("plugins.gitsigns", {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▎" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
      },
      signcolumn = false,
      watch_gitdir = {
          enable = false,
      },
    }))
  end
end

return M
