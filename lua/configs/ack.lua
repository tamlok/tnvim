local M = {}

function M.setup()
  -- Use ripgrep for searching
  -- Need to set it before loading
  -- Options include:
  -- --vimgrep -> Needed to parse the rg response properly for ack.vim
  -- --type-not sql -> Avoid huge sql file dumps as it slows down the search
  -- --smart-case -> Search case insensitive if all lowercase pattern, Search case sensitively otherwise
  vim.g.ackprg = 'rg --vimgrep --type-not sql --smart-case'
end

function M.config()
  -- Auto close the Quickfix list after pressing '<enter>' on a list item
  vim.g.ack_autoclose = 1

  -- Any empty ack search will search for the work the cursor is on
  vim.g.ack_use_cword_for_empty_search = 1
end

-- A wrapper of Ack to use vim.g.t_target_globs as globs
function M.ack_wrapper(args)
  local globs = ''
  if vim.g.t_target_globs ~= nil then
    for _, pattern in ipairs(vim.g.t_target_globs) do
        globs = globs .. ' -g "' .. pattern .. '"'
    end
    globs = globs .. ' '
  end
  vim.cmd("Ack " .. globs .. args)
end

return M
