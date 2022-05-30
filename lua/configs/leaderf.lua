local M = {}

local utils = require('core.utils')

function M.config()
  if utils.is_available('LeaderF') then
    vim.g.Lf_PreviewResult = {
      BufTag = 0,
      Function = 0
    }
    vim.g.Lf_WorkingDirectoryMode = 'a'
    vim.g.Lf_ShortcutF = '<leader>ff'
    vim.g.Lf_ShortcutB = '<leader>fb'
    vim.g.Lf_WildIgnore = {
      dir = {'.svn', '.git', '.hg'},
      file = {'*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]', '*.cov.*.report'}
    }
    vim.g.Lf_ShowHidden = 1
    vim.g.Lf_ShowDevIcons = 0
    vim.g.Lf_JumpToExistingWindow = 0
    vim.g.Lf_UseVersionControlTool = 0

    -- Popup mode
    vim.g.Lf_WindowPosition = 'popup'
    vim.g.Lf_PreviewInPopup = 1
    vim.g.Lf_StlSeparator = {
      left = '►',
      right = '◄',
      font = '',
    }

    vim.g.Lf_GtagsAutoGenerate = 0
    vim.g.Lf_GtagsGutentags = 1
    vim.g.Lf_CacheDirectory = vim.fn.expand('~')
    if (utils.get_os() == "win") then
      local scoop_conf = vim.fn.expand('~/scoop/apps/global/current/share/gtags/gtags.conf')
      if (utils.file_exists(scoop_conf)) then
        vim.g.Lf_Gtagsconf = scoop_conf
      end
    end
  end
end

return M
