local M = {}

-- Help to manage ctags and gtags files.
function M.update_ctags()
    vim.notify("Updating ctags...")
    local file_list_file = nil
    if vim.g.t_list_file_cmd ~= nil then
        file_list_file = '.filelist.user'
        local cmd = vim.g.t_list_file_cmd .. " > " .. file_list_file
        vim.fn.system(cmd)
    end

    local ctags_cmd = "ctags -R --fields=+niazS --extras=+q --c++-kinds=+px --output-format=e-ctags"
        .. " --languages=c,c++"
    if file_list_file ~= nil then
        ctags_cmd = ctags_cmd .. " -L " .. file_list_file
    end
    vim.cmd("AsyncRun -silent " .. ctags_cmd)
end

function M.update_gtags()
    vim.env.GTAGSFORCECPP = 1
    if require("core.utils").file_exists("GTAGS") then
        vim.notify("Updating gtags...")
        vim.cmd("AsyncRun -silent global --update")
        return
    end

    vim.notify("Generating gtags...")
    local file_list_file = nil
    if vim.g.t_list_file_cmd ~= nil then
        file_list_file = '.filelist.user'
        local cmd = vim.g.t_list_file_cmd .. " > " .. file_list_file
        vim.fn.system(cmd)
    end

    local gtags_cmd = "gtags"
    if file_list_file ~= nil then
        gtags_cmd = gtags_cmd .. " -f " .. file_list_file
    end
    vim.cmd("AsyncRun -silent " .. gtags_cmd)
end

return M
