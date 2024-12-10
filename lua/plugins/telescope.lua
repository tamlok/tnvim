return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
          "tamlok/telescope-fzf-native.nvim",
          enabled = vim.fn.executable "cmake" == 1,
          build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
      },
    },
    cmd = "Telescope",
    opts = function()
      local actions = require "telescope.actions"
      local get_icon = require("astronvim.utils").get_icon
      return {
        defaults = {
          git_worktrees = vim.g.git_worktrees,
          prompt_prefix = get_icon("Selected", 1),
          selection_caret = get_icon("Selected", 1),
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-u>"] = false, -- Make <c-u> to delete till the start of the line.
            },
            n = {
              q = actions.close,
              ["<C-c>"] = actions.close,
            },
          },
        },
      }
    end,
    config = require "plugins.configs.telescope",
  },
  {
    "fcying/telescope-ctags-outline.nvim",
    lazy = true,
    dependencies = {
      { "nvim-telescope/telescope.nvim" }
    }
  }
}
