local M = {}

function M.config()
  local status_ok, neotree = pcall(require, "neo-tree")
  if status_ok then
    vim.g.neo_tree_remove_legacy_commands = true
    neotree.setup(require("core.utils").user_plugin_opts("plugins.neo-tree", {
      popup_border_style = "rounded",
      enable_diagnostics = false,
      default_component_configs = {
        indent = {
          padding = 0,
          with_expanders = false,
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          default = "",
        },
        git_status = {
          symbols = {
            added = "",
            deleted = "",
            modified = "",
            renamed = "➜",
            untracked = "★",
            ignored = "◌",
            unstaged = "✗",
            staged = "✓",
            conflict = "",
          },
        },
      },
      window = {
        width = 35,
        mappings = {
          ["o"] = "open",
          -- Avoid conflict with which-key
          ["<space>"] = "none",
        },
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = false,
          hide_by_name = {
            ".DS_Store",
            "thumbs.db",
            "node_modules",
            "__pycache__",
          },
        },
        follow_current_file = false,
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
      },
      git_status = {
        window = {
          position = "float",
        },
      },
      event_handlers = {
        {
          event = "vim_buffer_enter",
          handler = function(_)
            if vim.bo.filetype == "neo-tree" then
              vim.wo.signcolumn = "auto"
            end
          end,
        },
      },
    }))
  end
end

return M
