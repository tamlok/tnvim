local M = {}

function M.config()
    vim.g.openbrowser_search_engines = {
        cplusplus = 'https://www.cplusplus.com/search.do?q={query}',
        qt = 'https://doc.qt.io/qt-5/search-results.html?q={query}',
    }
end

return M
