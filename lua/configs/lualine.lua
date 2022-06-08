local M = {}

local status = require "core.status"

function M.config()
  local status_ok, lualine = pcall(require, "lualine")
  if status_ok then
    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand "%:t") ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      check_git_workspace = function()
        local filepath = vim.fn.expand "%:p:h"
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
      end,
    }

    local spacer = {
      function()
        return " "
      end,
      padding = { left = 0, right = 0 },
    }

    lualine.setup(require("core.utils").user_plugin_opts("plugins.lualine", {
      options = {
        disabled_filetypes = { "NvimTree", "neo-tree", "dashboard", "Outline" },
        component_separators = "",
        section_separators = "",
        globalstatus = false,
      },
      sections = {
        -- Buffer number.
        lualine_a = { spacer, '%-3n' },
        lualine_b = { 'filename', 'encoding', 'fileformat' },
        lualine_c = {
          {
            "branch",
            icon = "",
            padding = { left = 2, right = 1 },
          },
          {
            "filetype",
            cond = conditions.buffer_not_empty,
            padding = { left = 2, right = 1 },
          },
          {
            "diff",
            symbols = { added = " ", modified = "柳", removed = " " },
            cond = conditions.hide_in_width,
            padding = { left = 2, right = 1 },
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            padding = { left = 2, right = 1 },
          },
          {
            function()
              return "%="
            end,
          },
        },
        lualine_x = {
          {
            status.lsp_progress,
            padding = { left = 0, right = 1 },
            cond = conditions.hide_in_width,
          },
          {
            status.lsp_name,
            icon = " ",
            padding = { left = 0, right = 1 },
            cond = conditions.hide_in_width,
          },
          {
            status.treesitter_status,
            padding = { left = 1, right = 0 },
            cond = conditions.hide_in_width,
          },
          {
            "%l-%L %c%V",
          },
          {
            "progress",
          },
          {
            status.progress_bar,
            padding = { left = 1, right = 2 },
            cond = nil,
          },
        },
        lualine_y = {},
        lualine_z = { spacer },
      },
      inactive_sections = {
        lualine_a = { '%-3n' },
        lualine_b = {},
        lualine_c = { 'filename', 'encoding', 'fileformat' },
        lualine_x = { "%l-%L %c%V", "progress" },
        lualine_y = {},
        lualine_z = {},
      },
    }))
  end
end

return M
