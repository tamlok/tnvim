-- Provides utils for the Lualine status line components
local M = {}

local status = require "astronvim.utils.status"
local utils = require "astronvim.utils"
local luv = vim.uv or vim.loop -- TODO: REMOVE WHEN DROPPING SUPPORT FOR Neovim v0.9

function M.spacer()
    return {
        function()
            return " "
        end,
        padding = { left = 0, right = 0 },
    }
end

function M.buffer_empty()
    return vim.fn.empty(vim.fn.expand "%:t") == 1
end

function M.small_window()
    return vim.fn.winwidth(0) < 80
end

function M.lsp_progress(opts)
  local spinner = utils.get_spinner("LSPLoading", 1) or { "" }
  local _, Lsp = next(astronvim.lsp.progress)
  return status.stylize(Lsp and (spinner[math.floor(luv.hrtime() / 12e7) % #spinner + 1] .. table.concat({
      Lsp.title or "",
      Lsp.message or "",
      Lsp.percentage and "(" .. Lsp.percentage .. "%)" or "",
  }, " ")), opts)
end

function M.lsp_name(opts)
  opts = utils.extend_tbl({ expand_null_ls = true, truncate = 0.25 }, opts)
  local buf_client_names = {}
  for _, client in pairs(vim.lsp.get_clients { bufnr = self and self.bufnr or 0 }) do
      if client.name == "null-ls" and opts.expand_null_ls then
          local null_ls_sources = {}
          for _, type in ipairs { "FORMATTING", "DIAGNOSTICS" } do
              for _, source in ipairs(status.null_ls_sources(vim.bo.filetype, type)) do
                  null_ls_sources[source] = true
              end
          end
          vim.list_extend(buf_client_names, vim.tbl_keys(null_ls_sources))
      else
          table.insert(buf_client_names, client.name)
      end
  end
  local str = table.concat(buf_client_names, ", ")
  if type(opts.truncate) == "number" then
      local max_width = math.floor(status.width() * opts.truncate)
      if #str > max_width then str = string.sub(str, 0, max_width) .. "…" end
  end
  return status.stylize(str, opts)
end

function M.treesitter_info()
    return 'TS';
end

return M
