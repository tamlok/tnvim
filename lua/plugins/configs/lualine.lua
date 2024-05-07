local lualine_utils = require "astronvim.utils.lualine"
local condition = require "astronvim.utils.condition"

return function(_, opts)
  local status_ok, lualine = pcall(require, "lualine")
  if status_ok then
    lualine.setup({
      options = {
        disabled_filetypes = { "NvimTree", "nerdtree", "neo-tree", "dashboard", "Outline" },
        component_separators = "",
        section_separators = "",
        globalstatus = false,
      },
      sections = {
        -- Buffer number.
        lualine_a = { lualine_utils.spacer(), '%-3n' },
        lualine_b = { 'filename', 'encoding', 'fileformat' },
        lualine_c = {
          {
            "filetype",
            cond = function() return not lualine_utils.buffer_empty() end,
            padding = { left = 2, right = 1 },
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            padding = { left = 1, right = 1 },
          },
          {
            function()
              -- Right-aligned seperation point.
              return "%="
            end,
          },
        },
        lualine_x = {
          {
            lualine_utils.lsp_progress,
            padding = { left = 1, right = 1 },
            cond = function() return not lualine_utils.small_window() end,
          },
          {
            lualine_utils.lsp_name,
            padding = { left = 1, right = 1 },
            cond = function() return not lualine_utils.small_window() end,
          },
          {
            lualine_utils.treesitter_info,
            padding = { left = 1, right = 1 },
            cond = function() return (not lualine_utils.small_window()) and condition.treesitter_available() end,
          }
        },
        lualine_y = {
          "%l/%L:%c%V",
          "progress",
        },
        lualine_z = { lualine_utils.spacer() },
      },
      inactive_sections = {
        lualine_a = { lualine_utils.spacer(), '%-3n' },
        lualine_b = {},
        lualine_c = { 'filename', 'encoding', 'fileformat' },
        lualine_x = {},
        lualine_y = { "%l-%L:%c%V", "progress" },
        lualine_z = {},
      },
    })
  end
end
