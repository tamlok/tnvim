local M = {}

function M.config()
  local present, filetype = pcall(require, "filetype")
  if present then
    filetype.setup({
      overrides = {
        extensions = {
          qss = "css"
        }
      }
    })
  end
end

return M
