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

vim.g.t_old_cursorline = vim.o.cursorline
vim.g.t_old_laststatus = vim.o.laststatus

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
    command = "let g:t_old_laststatus = &laststatus | set laststatus=0",
  })
  cmd("BufWinLeave", {
    desc = "Reenable statusline/cursorline when leaving dashboard",
    group = "dashboard_settings",
    pattern = "<buffer>",
    command = "let &laststatus = g:t_old_laststatus | let &cursorline = g:t_old_cursorline",
  })
  cmd("BufEnter", {
    desc = "No cursorline on dashboard",
    group = "dashboard_settings",
    pattern = "*",
    command = "if &ft is 'dashboard' | let g:t_old_cursorline = &cursorline | set nocursorline | endif",
  })
end

if utils.is_available "vim-fswitch" then
  augroup("fswitch_settings", {})
  cmd("BufEnter", {
    group = "fswitch_settings",
    pattern = "*.h",
    command = "let b:fswitchdst = 'c,cpp,m,cc' | let b:fswitchlocs = 'reg:|include.*|src/**|'",
  })
  cmd("BufEnter", {
    group = "fswitch_settings",
    pattern = "*.cc",
    command = "let b:fswitchdst = 'h,hpp'",
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

vim.cmd("hi ExtraWhitespace ctermbg=202 guibg=#ff5f00")
cmd("InsertEnter", {
  desc = "Highlight extra whitespace",
  group = "buffer_cmd",
  command = "match ExtraWhitespace /\\s\\+\\%#\\@<!$/"
})
cmd("InsertLeave", {
  desc = "Highlight extra whitespace",
  group = "buffer_cmd",
  command = "match ExtraWhitespace /\\s\\+$/",
})

create_command("TVScoop", require("core.utils").install_scoop, { desc = "Install Scoop on Windows" })
create_command("TVUtils", require("core.utils").install_utils, { desc = "Install utils like ripgrep/ctags/global" })
create_command("TVPynvim", require("core.utils").install_pynvim, { desc = "Install Pynvim" })
create_command("TVLlvm", require("core.utils").install_llvm, { desc = "Install LLVM" })
create_command("TVTab",
  function(opts)
    require("core.utils").set_tab_stop_width(tonumber(opts.args))
  end,
  {
    nargs = 1,
    desc = "Set Tab stop width",
  })
create_command("TVAck",
  function(opts)
    require("configs.ack").ack_wrapper(opts.args)
  end,
  {
    nargs = "*",
    desc = "Ack wrapper respecting globs defined as vim.g.t_target_globs",
  })

return M
