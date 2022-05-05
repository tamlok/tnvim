local M = {}

local utils = require "core.utils"

local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local create_command = vim.api.nvim_create_user_command

local laststatus = vim.opt.laststatus

augroup("packer_user_config", {})
cmd("BufWritePost", {
  desc = "Auto Compile plugins.lua file",
  group = "packer_user_config",
  command = "source <afile> | PackerCompile",
  pattern = "plugins.lua",
})

augroup("cursor_off", {})
cmd("WinLeave", {
  desc = "No cursorline",
  group = "cursor_off",
  command = "set nocursorline",
})
cmd("WinEnter", {
  desc = "No cursorline",
  group = "cursor_off",
  command = "set cursorline",
})

if utils.is_available "dashboard-nvim" then
  augroup("dashboard_settings", {})
  if utils.is_available "bufferline.nvim" then
    cmd("FileType", {
      desc = "Disable tabline for dashboard",
      group = "dashboard_settings",
      pattern = "dashboard",
      command = "set showtabline=0",
    })
    cmd("BufWinLeave", {
      desc = "Reenable tabline when leaving dashboard",
      group = "dashboard_settings",
      pattern = "<buffer>",
      command = "set showtabline=2",
    })
  end
  cmd("FileType", {
    desc = "Disable statusline for dashboard",
    group = "dashboard_settings",
    pattern = "dashboard",
    command = "let g:old_laststatus = &laststatus | set laststatus=0",
  })
  cmd("BufWinLeave", {
    desc = "Reenable statusline/cursorline when leaving dashboard",
    group = "dashboard_settings",
    pattern = "<buffer>",
    command = "let &laststatus = g:old_laststatus | let &cursorline = g:old_cursorline",
  })
  cmd("BufEnter", {
    desc = "No cursorline on dashboard",
    group = "dashboard_settings",
    pattern = "*",
    command = "if &ft is 'dashboard' | let g:old_cursorline = &cursorline | set nocursorline | endif",
  })
end

vim.g.t_last_active_tab = 1

augroup("buffer_cmd", {})
-- Remember last-active tab
cmd("TabLeave", {
  desc = "Record last-active tab",
  group = "buffer_cmd",
  command = "let g:t_last_active_tab = tabpagenr()",
})
-- Auto enable/disable input method when entering/leaving insert mode
cmd("InsertLeave", {
  desc = "Disable input method",
  group = "buffer_cmd",
  command = "set imdisable | set iminsert=0",
})
cmd("InsertEnter", {
  desc = "Enable input method",
  group = "buffer_cmd",
  command = "set noimdisable | set iminsert=0",
})

create_command("TVScoop", require("core.utils").install_scoop, { desc = "Install Scoop on Windows" })
create_command("TVInstallUtils", require("core.utils").install_utils, { desc = "Install utils like ripgrep/ctags/global" })

return M
