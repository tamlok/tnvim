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
    command = "let b:fswitchdst = 'h,hpp' | let b:fswitchlocs = 'reg:|src.*|include/**|'",
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

cmd("FileType", {
  desc = "Set format options",
  pattern = "*",
  group = "buffer_cmd",
  command = "setlocal formatoptions-=cro",
})

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
create_command("TVCtags", require("core.tags").update_ctags, { desc = "Update ctags" })
create_command("TVGtags", require("core.tags").update_gtags, { desc = "Update gtags" })

return M
