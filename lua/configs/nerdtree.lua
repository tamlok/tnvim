local M = {}

function M.config()
  vim.g.NERDTreeQuitOnOpen = 1
  vim.g.NERDTreeAutoDeleteBuffer=1
  -- Display bookmarks table on startup
  vim.g.NERDTreeShowBookmarks=1
  -- Let <CR> on file node open the file and keep the tree open
  vim.g.NERDTreeCustomOpenArgs= {
    file = {
      reuse = 'currenttab',
      where = 'p',
      keepopen = 1,
      stay = 0,
    },
  }
end

return M
