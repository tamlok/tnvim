local M = {}

function M.config()
    vim.g.gutentags_define_advanced_commands = 1
    vim.g.gutentags_enabled = 0

    vim.g.gutentags_generate_on_new = 1
    vim.g.gutentags_generate_on_missing = 1
    vim.g.gutentags_generate_on_empty_buffer = 0
    vim.g.gutentags_generate_on_write = 1

    vim.g.gutentags_project_root = {'.root', '.svn', '.git', '.hg', '.project', 'dirs.proj', 'dirs'}
    vim.g.gutentags_ctags_tagfile = 'tags'

    local tags_dir = vim.fn.expand('~/.cache/tags')
    if not vim.fn.isdirectory(tags_dir) then
        vim.cmd("silent! call mkdir(" .. tags_dir .. ", 'p')")
    end
    vim.g.gutentags_cache_dir = tags_dir

    vim.g.gutentags_ctags_extra_args = {
        '--fields=+niazS',
        '--extras=+q',
        '--c++-kinds=+px',
        '--c-kinds=+px',
        -- Used for Universal Ctags
        '--output-format=e-ctags',
    }

    local tag_common_exclude = {
        '*.json',
        '*.md',
        '*.obj',
        '*.bin',
        '*.pdb' ,
        '*.dll' ,
        '*.so' ,
        '*.lib' ,
        '*.ini',
        '*.log',
        '*.txt',
        '*.vcxproj',
        '*.proj',
        '*.vimrc',
        '*.csv',
        '*.css',
        '*.html',
        '*.js',
        '*.ts'
    }
    vim.g.gutentags_ctags_exclude = tag_common_exclude
    vim.g.gutentags_exclude_filetypes = tag_common_exclude
    vim.g.gutentags_modules = {}
    if vim.fn.executable("ctags") then
        vim.g.gutentags_modules = vim.fn.extend(vim.g.gutentags_modules, {'ctags'})
    end
    if vim.fn.executable("gtags-cscope") and vim.fn.executable("gtags") then
        vim.g.gutentags_modules = vim.fn.extend(vim.g.gutentags_modules, {'gtags_cscope'})
        vim.g.gutentags_cscope_executable = "gtags-cscope"
    end

    vim.g.gutentags_define_advanced_commands = 1
end

return M
