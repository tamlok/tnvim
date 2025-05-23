local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_create_user_command
local namespace = vim.api.nvim_create_namespace

local utils = require "astronvim.utils"
local is_available = utils.is_available
local astroevent = utils.event

autocmd("BufReadPre", {
  desc = "Disable certain functionality on very large files",
  group = augroup("large_buf", { clear = true }),
  callback = function(args)
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    vim.b[args.buf].large_buf = (ok and stats and stats.size > vim.g.max_file.size)
      or vim.api.nvim_buf_line_count(args.buf) > vim.g.max_file.lines
  end,
})

local terminal_settings_group = augroup("terminal_settings", { clear = true })
-- TODO: drop when dropping support for Neovim v0.9
if vim.fn.has "nvim-0.9" == 1 and vim.fn.has "nvim-0.9.4" == 0 then
  -- HACK: Disable custom statuscolumn for terminals because truncation/wrapping bug
  -- https://github.com/neovim/neovim/issues/25472
  autocmd("TermOpen", {
    group = terminal_settings_group,
    desc = "Disable custom statuscolumn for terminals to fix neovim/neovim#25472",
    callback = function() vim.opt_local.statuscolumn = nil end,
  })
end
autocmd("TermOpen", {
  group = terminal_settings_group,
  desc = "Disable foldcolumn and signcolumn for terminals",
  callback = function()
    vim.opt_local.foldcolumn = "0"
    vim.opt_local.signcolumn = "no"
  end,
})

local bufferline_group = augroup("bufferline", { clear = true })
autocmd({ "BufAdd", "BufEnter", "TabNewEntered" }, {
  desc = "Update buffers when adding new buffers",
  group = bufferline_group,
  callback = function(args)
    local buf_utils = require "astronvim.utils.buffer"
    if not vim.t.bufs then vim.t.bufs = {} end
    if not buf_utils.is_valid(args.buf) then return end
    if args.buf ~= buf_utils.current_buf then
      buf_utils.last_buf = buf_utils.is_valid(buf_utils.current_buf) and buf_utils.current_buf or nil
      buf_utils.current_buf = args.buf
    end
    local bufs = vim.t.bufs
    if not vim.tbl_contains(bufs, args.buf) then
      table.insert(bufs, args.buf)
      vim.t.bufs = bufs
    end
    vim.t.bufs = vim.tbl_filter(buf_utils.is_valid, vim.t.bufs)
    astroevent "BufsUpdated"
  end,
})
autocmd({ "BufDelete", "TermClose" }, {
  desc = "Update buffers when deleting buffers",
  group = bufferline_group,
  callback = function(args)
    local removed
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
      local bufs = vim.t[tab].bufs
      if bufs then
        for i, bufnr in ipairs(bufs) do
          if bufnr == args.buf then
            removed = true
            table.remove(bufs, i)
            vim.t[tab].bufs = bufs
            break
          end
        end
      end
    end
    vim.t.bufs = vim.tbl_filter(require("astronvim.utils.buffer").is_valid, vim.t.bufs)
    if removed then astroevent "BufsUpdated" end
    vim.cmd.redrawtabline()
  end,
})

local view_group = augroup("auto_view", { clear = true })
autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
  desc = "Save view with mkview for real files",
  group = view_group,
  callback = function(args)
    if vim.b[args.buf].view_activated then vim.cmd.mkview { mods = { emsg_silent = true } } end
  end,
})
autocmd("BufWinEnter", {
  desc = "Try to load file view if available and enable view saving for real files",
  group = view_group,
  callback = function(args)
    if not vim.b[args.buf].view_activated then
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
      local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
      local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
      if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
        vim.b[args.buf].view_activated = true
        vim.cmd.loadview { mods = { emsg_silent = true } }
      end
    end
  end,
})

autocmd("BufWinEnter", {
  desc = "Make q close help, man, quickfix, dap floats",
  group = augroup("q_close_windows", { clear = true }),
  callback = function(args)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
    if vim.tbl_contains({ "help", "nofile", "quickfix" }, buftype) and vim.fn.maparg("q", "n") == "" then
      vim.keymap.set("n", "q", "<cmd>close<cr>", {
        desc = "Close window",
        buffer = args.buf,
        silent = true,
        nowait = true,
      })
    end
  end,
})

autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = augroup("highlightyank", { clear = true }),
  pattern = "*",
  callback = function() vim.highlight.on_yank() end,
})

autocmd("FileType", {
  desc = "Unlist quickfist buffers",
  group = augroup("unlist_quickfist", { clear = true }),
  pattern = "qf",
  callback = function() vim.opt_local.buflisted = false end,
})

autocmd("BufEnter", {
  desc = "Quit AstroNvim if more than one window is open and only sidebar windows are list",
  group = augroup("auto_quit", { clear = true }),
  callback = function()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    -- Both neo-tree and aerial will auto-quit if there is only a single window left
    if #wins <= 1 then return end
    local sidebar_fts = { aerial = true, ["neo-tree"] = true }
    for _, winid in ipairs(wins) do
      if vim.api.nvim_win_is_valid(winid) then
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
        -- If any visible windows are not sidebars, early return
        if not sidebar_fts[filetype] then
          return
        -- If the visible window is a sidebar
        else
          -- only count filetypes once, so remove a found sidebar from the detection
          sidebar_fts[filetype] = nil
        end
      end
    end
    if #vim.api.nvim_list_tabpages() > 1 then
      vim.cmd.tabclose()
    else
      vim.cmd.qall()
    end
  end,
})

-- HACK: indent blankline doesn't properly refresh when scrolling the window
-- remove when fixed upstream: https://github.com/lukas-reineke/indent-blankline.nvim/issues/489
if is_available "indent-blankline.nvim" then
  autocmd("WinScrolled", {
    desc = "Refresh indent blankline on window scroll",
    group = augroup("indent_blankline_refresh_scroll", { clear = true }),
    callback = function()
      -- TODO: remove neovim version check when dropping support for Neovim 0.8
      if vim.fn.has "nvim-0.9" ~= 1 or (vim.v.event.all and vim.v.event.all.leftcol ~= 0) then
        pcall(vim.cmd.IndentBlanklineRefresh)
      end
    end,
  })
end

if is_available "resession.nvim" then
  autocmd("VimLeavePre", {
    desc = "Save session on close",
    group = augroup("resession_auto_save", { clear = true }),
    callback = function()
      local buf_utils = require "astronvim.utils.buffer"
      local autosave = buf_utils.sessions.autosave
      if autosave and buf_utils.is_valid_session() then
        local save = require("resession").save
        if autosave.last then save("Last Session", { notify = false }) end
        if autosave.cwd then save(vim.fn.getcwd(), { dir = "dirsession", notify = false }) end
      end
    end,
  })
end

if is_available "neo-tree.nvim" then
  autocmd("BufEnter", {
    desc = "Open Neo-Tree on startup with directory",
    group = augroup("neotree_start", { clear = true }),
    callback = function()
      if package.loaded["neo-tree"] then
        vim.api.nvim_del_augroup_by_name "neotree_start"
      else
        local stats = (vim.uv or vim.loop).fs_stat(vim.api.nvim_buf_get_name(0)) -- TODO: REMOVE vim.loop WHEN DROPPING SUPPORT FOR Neovim v0.9
        if stats and stats.type == "directory" then
          vim.api.nvim_del_augroup_by_name "neotree_start"
          require "neo-tree"
        end
      end
    end,
  })
  autocmd("TermClose", {
    pattern = "*lazygit*",
    desc = "Refresh Neo-Tree when closing lazygit",
    group = augroup("neotree_refresh", { clear = true }),
    callback = function()
      local manager_avail, manager = pcall(require, "neo-tree.sources.manager")
      if manager_avail then
        for _, source in ipairs { "filesystem", "git_status", "document_symbols" } do
          local module = "neo-tree.sources." .. source
          if package.loaded[module] then manager.refresh(require(module).name) end
        end
      end
    end,
  })
end

autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
  desc = "AstroNvim user events for file detection",
  group = augroup("file_user_events", { clear = true }),
  callback = function(args)
    local current_file = vim.fn.resolve(vim.fn.expand "%")
    if not (current_file == "" or vim.api.nvim_get_option_value("buftype", { buf = args.buf }) == "nofile") then
      astroevent "File"
    end
  end,
})

augroup("buffer_cmd", { clear = true })
-- Remember last-active tab
autocmd("TabLeave", {
  desc = "Record last-active tab",
  group = "buffer_cmd",
  callback = function()
    astronvim.last_active_tab = vim.fn.tabpagenr()
  end,
})

-- Auto enable/disable input method when entering/leaving insert mode
autocmd("InsertLeave", {
  desc = "Disable input method",
  group = "buffer_cmd",
  command = "silent! set imdisable | set iminsert=0",
})
autocmd("InsertEnter", {
  desc = "Enable input method",
  group = "buffer_cmd",
  command = "set noimdisable | set iminsert=0",
})

vim.cmd("hi ExtraWhitespace ctermbg=202 guibg=#ff5f00")
autocmd("InsertEnter", {
  desc = "Highlight extra whitespace",
  group = "buffer_cmd",
  command = "match ExtraWhitespace /\\s\\+\\%#\\@<!$/"
})
autocmd("InsertLeave", {
  desc = "Highlight extra whitespace",
  group = "buffer_cmd",
  command = "match ExtraWhitespace /\\s\\+$/",
})

autocmd("FileType", {
  desc = "Set format options",
  pattern = "*",
  group = "buffer_cmd",
  command = "setlocal formatoptions-=cro",
})

cmd("TVTab",
  function(opts)
    utils.set_tab_stop_width(tonumber(opts.args))
  end,
  {
    nargs = 1,
    desc = "Set Tab stop width",
  })
-- cmd("TVCtags", require("astronvim.utils.tags").update_ctags, { desc = "Update ctags" })
-- cmd("TVGtags", require("astronvim.utils.tags").update_gtags, { desc = "Update gtags" })
