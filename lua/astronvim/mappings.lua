-- TODO: replace <leader> to <Leader> everywhere in AstroNvim v4 to match vimdoc
local utils = require "astronvim.utils"
local get_icon = utils.get_icon
local is_available = utils.is_available
local ui = require "astronvim.utils.ui"

local maps = require("astronvim.utils").empty_map_table()

local sections = {
  f = { desc = "Find" },
  P = { desc = "Packages" },
  l = { desc = "LSP" },
  u = { desc = "UI/UX" },
  d = { desc = "Debugger" },
  g = { desc = "Git" },
  -- S = { desc = get_icon("Session", 1, true) .. "Session" },
  t = { desc = "Terminal" },
  w = { desc = "Windows" },
  r = { desc = "Run" },
}

-- Windows management
maps.n["<leader>w"] = sections.w
maps.n["<leader>ww"] = { "<cmd>w<cr>", desc = "Save" }
maps.n["<leader>wq"] = { "<cmd>confirm q<cr>", desc = "Quit" }
maps.n["<leader>wQ"] = { "<cmd>confirm qall<cr>", desc = "Quit all" }
maps.n["<leader>wt"] = { "<cmd>tabedit<cr>", desc = "New tab" }
maps.n["<leader>wT"] = { "<cmd>tabclose<cr>", desc = "Close tab" }
maps.n["<leader>wz"] = { ui.zoom_restore_current_window, desc = "Zoom/Restore current window" }
maps.n["<leader>wc"] = {
  function()
    local beforeCnt = vim.call("winnr", "$")
    vim.cmd("copen")
    if beforeCnt == vim.call("winnr", "$") then
      vim.cmd("cclose")
    end
  end,
  desc = "Toggle quickfix list"
}
maps.n["<leader>wl"] = {
  function()
    local beforeCnt = vim.call("winnr", "$")
    vim.cmd("lopen")
    if beforeCnt == vim.call("winnr", "$") then
      vim.cmd("lclose")
    end
  end,
  desc = "Toggle location list"
}
-- NeoTree
if is_available "neo-tree.nvim" then
  maps.n["<leader>we"] = { "<cmd>Neotree toggle reveal<cr>", desc = "Toggle explorer" }
  maps.n["<leader>wo"] = {
    function()
      if vim.bo.filetype == "neo-tree" then
        vim.cmd.wincmd "p"
      else
        vim.cmd.Neotree "focus"
      end
    end,
    desc = "Toggle explorer focus",
  }
end

-- Buffers
maps.n["]b"] = { "<cmd>bnext<cr>", desc = "Next buffer" }
maps.n["[b"] = { "<cmd>bprevious<cr>", desc = "Previous buffer" }
maps.n["]B"] = { "<cmd>blast<cr>", desc = "Last buffer" }
maps.n["[B"] = { "<cmd>bfirst<cr>", desc = "First buffer" }

if vim.fn.exists("g:neovide") or vim.fn.exists("g:nvy") then
  maps.n["<C-6>"] = { "<C-^>", desc = "Alternate between current and previous buffer" }
end

-- Quickfix
maps.n["]c"] = { "<cmd>cnext<cr>", desc = "Next quickfix" }
maps.n["[c"] = { "<cmd>cprevious<cr>", desc = "Previous quickfix" }
maps.n["]C"] = { "<cmd>clast<cr>", desc = "Last quickfix" }
maps.n["[C"] = { "<cmd>cfirst<cr>", desc = "First quickfix" }

-- Location list
maps.n["]l"] = { "<cmd>lnext<cr>", desc = "Next location" }
maps.n["[l"] = { "<cmd>lprevious<cr>", desc = "Previous location" }
maps.n["]L"] = { "<cmd>llast<cr>", desc = "Last location" }
maps.n["[L"] = { "<cmd>lfirst<cr>", desc = "First location" }

-- Tag
maps.n["]o"] = { "<cmd>tnext<cr>", desc = "Next tag" }
maps.n["[o"] = { "<cmd>tprevious<cr>", desc = "Previous tag" }
maps.n["]O"] = { "<cmd>tlast<cr>", desc = "Last tag" }
maps.n["[O"] = { "<cmd>tfirst<cr>", desc = "First tag" }

-- Preview tag
maps.n["]p"] = { "<cmd>ptnext<cr>", desc = "Next preview tag" }
maps.n["[p"] = { "<cmd>ptprevious<cr>", desc = "Previous preview tag" }
maps.n["]P"] = { "<cmd>ptlast<cr>", desc = "Last preview tag" }
maps.n["[P"] = { "<cmd>ptfirst<cr>", desc = "First preview tag" }

-- Navigate tabs
maps.n["]t"] = { "<cmd>tabnext<cr>", desc = "Next tab" }
maps.n["[t"] = { "<cmd>tabprevious<cr>", desc = "Previous tab" }
maps.n["]T"] = { "<cmd>tablast<cr>", desc = "Last tab" }
maps.n["[T"] = { "<cmd>tabfirst<cr>", desc = "First tab" }
maps.n["<t"] = { "<cmd>-tabmove<cr>", desc = "Move tab to the left" }
maps.n[">t"] = { "<cmd>+tabmove<cr>", desc = "Move tab to the right" }

maps.n["<leader>0"] = {
  function() vim.cmd("tabn " .. astronvim.last_active_tab) end,
  desc = "Alternate between current and previous active tab"
}
maps.n["<leader>1"] = { "<esc>1gt", desc = "Go to tab 1" }
maps.n["<leader>2"] = { "<esc>2gt", desc = "Go to tab 2" }
maps.n["<leader>3"] = { "<esc>3gt", desc = "Go to tab 3" }
maps.n["<leader>4"] = { "<esc>4gt", desc = "Go to tab 4" }
maps.n["<leader>5"] = { "<esc>5gt", desc = "Go to tab 5" }
maps.n["<leader>6"] = { "<esc>6gt", desc = "Go to tab 6" }
maps.n["<leader>7"] = { "<esc>7gt", desc = "Go to tab 7" }
maps.n["<leader>8"] = { "<esc>8gt", desc = "Go to tab 8" }
maps.n["<leader>9"] = { "<esc>9gt", desc = "Go to tab 9" }

-- Copy/Paste
maps.n["<leader>p"] = { '"+', desc = "Use the selection register" }
maps.v["<leader>p"] = { '"+', desc = "Use the selection register" }
maps.n["<leader>o"] = { '"_', desc = "Use the black hole register" }
maps.v["<leader>o"] = { '"_', desc = "Ues the black hole register" }

-- Stay in indent mode
maps.v["<S-Tab>"] = { "<gv", desc = "Unindent line" }
maps.v["<Tab>"] = { ">gv", desc = "Indent line" }

-- Improved terminal navigation
maps.t["<C-h>"] = { "<cmd>wincmd h<cr>", desc = "Terminal left window navigation" }
maps.t["<C-j>"] = { "<cmd>wincmd j<cr>", desc = "Terminal down window navigation" }
maps.t["<C-k>"] = { "<cmd>wincmd k<cr>", desc = "Terminal up window navigation" }
maps.t["<C-l>"] = { "<cmd>wincmd l<cr>", desc = "Terminal right window navigation" }

maps.n["<leader>."] = { '<cmd>"+yiw<cr>', desc = "Yank the word under cursor" }
maps.n["<leader><space>"] = { "<cmd>nohlsearch<cr>", desc = "No highlight search" }

-- Comment
if is_available "Comment.nvim" then
  maps.n["<leader>/"] = {
    function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
    desc = "Toggle comment line",
  }
  maps.v["<leader>/"] = {
    "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
    desc = "Toggle comment for selection",
  }
end

-- Package Manager
maps.n["<leader>P"] = sections.P
maps.n["<leader>Pa"] = {
  function()
    require("lazy").sync { wait = true }
    if is_available "mason.nvim" then
      require("astronvim.utils.mason").update_all()
    end
  end,
  desc = "Update plugins and Mason packages"
}
maps.n["<leader>Pi"] = { function() require("lazy").install() end, desc = "Plugins install" }
maps.n["<leader>Ps"] = { function() require("lazy").home() end, desc = "Plugins status" }
maps.n["<leader>PS"] = { function() require("lazy").sync() end, desc = "Plugins sync" }
maps.n["<leader>Pu"] = { function() require("lazy").check() end, desc = "Plugins check updates" }
maps.n["<leader>PU"] = { function() require("lazy").update() end, desc = "Plugins update" }
if is_available "mason.nvim" then
  maps.n["<leader>Pm"] = { "<cmd>Mason<cr>", desc = "Mason installer" }
  maps.n["<leader>PM"] = { "<cmd>MasonUpdateAll<cr>", desc = "Mason update" }
end

maps.n["<C-h>"] = { "<C-w>h", desc = "Move to left split" }
maps.n["<C-j>"] = { "<C-w>j", desc = "Move to below split" }
maps.n["<C-k>"] = { "<C-w>k", desc = "Move to above split" }
maps.n["<C-l>"] = { "<C-w>l", desc = "Move to right split" }
maps.n["<C-Up>"] = { "<cmd>resize -2<cr>", desc = "Resize split up" }
maps.n["<C-Down>"] = { "<cmd>resize +2<cr>", desc = "Resize split down" }
maps.n["<C-Left>"] = { "<cmd>vertical resize -2<cr>", desc = "Resize split left" }

-- SymbolsOutline
if is_available "aerial.nvim" then
  maps.n["<leader>l"] = sections.l
  maps.n["<leader>lS"] = { function() require("aerial").toggle() end, desc = "Symbols outline" }
end

-- Telescope
if is_available "telescope.nvim" then
  maps.n["<leader>f"] = sections.f
  maps.n["<leader>g"] = sections.g
  maps.n["<leader>gb"] =
    { function() require("telescope.builtin").git_branches { use_file_path = true } end, desc = "Git branches" }
  maps.n["<leader>gc"] = {
    function() require("telescope.builtin").git_commits { use_file_path = true } end,
    desc = "Git commits (repository)",
  }
  maps.n["<leader>gC"] = {
    function() require("telescope.builtin").git_bcommits { use_file_path = true } end,
    desc = "Git commits (current file)",
  }
  maps.n["<leader>gt"] =
    { function() require("telescope.builtin").git_status { use_file_path = true } end, desc = "Git status" }
  maps.n["<leader>f<cr>"] = { function() require("telescope.builtin").resume() end, desc = "Resume previous search" }
  maps.n["<leader>f'"] = { function() require("telescope.builtin").marks() end, desc = "Find marks" }
  maps.n["<leader>f/"] =
    { function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Find words in current buffer" }
  maps.n["<leader>fb"] = { function() require("telescope.builtin").buffers() end, desc = "Find buffers" }
  maps.n["<leader>fc"] = { function() require("telescope.builtin").grep_string() end, desc = "Find word under cursor" }
  maps.n["<leader>fC"] = { function() require("telescope.builtin").commands() end, desc = "Find commands" }
  maps.n["<leader>ff"] = { function() require("telescope.builtin").find_files({ previewer = false }) end, desc = "Find files" }
  maps.n["<leader>fF"] = {
    function() require("telescope.builtin").find_files { previewer = false, hidden = true, no_ignore = true } end,
    desc = "Find all files",
  }
  maps.n["<leader>fh"] = { function() require("telescope.builtin").help_tags() end, desc = "Find help" }
  maps.n["<leader>fm"] = { function() require("telescope.builtin").man_pages() end, desc = "Find man" }
  if is_available "nvim-notify" then
    maps.n["<leader>fn"] =
      { function() require("telescope").extensions.notify.notify() end, desc = "Find notifications" }
  end
  maps.n["<leader>fo"] = { function() require("telescope.builtin").oldfiles({ previewer = false }) end, desc = "Find history files" }
  maps.n["<leader>fw"] = { function() require("telescope.builtin").live_grep() end, desc = "Find words" }
  maps.n["<leader>fW"] = {
    function()
      require("telescope.builtin").live_grep {
        additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
      }
    end,
    desc = "Find words in all files",
  }
  maps.n["<leader>fa"] = { function() require('telescope').extensions.ctags_outline.outline() end, desc = "Find tags in current buffer" }
  maps.n["<leader>fA"] = { function() require('telescope').extensions.ctags_outline.outline({ buf = "all" }) end, desc = "Find tags in all buffers" }
  maps.n["<leader>l"] = sections.l
  maps.n["<leader>ls"] = {
    function()
      local aerial_avail, _ = pcall(require, "aerial")
      if aerial_avail then
        require("telescope").extensions.aerial.aerial()
      else
        require("telescope.builtin").lsp_document_symbols()
      end
    end,
    desc = "Search symbols",
  }
end

-- LSP
-- Some mappings are defined in lsp.lua.
maps.n["<leader>l"] = sections.l
maps.n["<leader>lq"] = { function() vim.diagnostic.hide() end, desc = "Hide diagnostic" }
maps.n["<leader>lz"] = { function() vim.lsp.buf.hover() end, desc = "Hover information" }
maps.n["<leader>lb"] = { utils.show_current_symbol , desc = "Show current symbol in notification" }
maps.n["<leader>lc"] = { "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch between source and header files" }

-- Terminal
if is_available "toggleterm.nvim" then
  maps.n["<leader>t"] = sections.t
  if vim.fn.executable "lazygit" == 1 then
    maps.n["<leader>g"] = sections.g
    maps.n["<leader>gg"] = {
      function()
        local worktree = require("astronvim.utils.git").file_worktree()
        local flags = worktree and (" --work-tree=%s --git-dir=%s"):format(worktree.toplevel, worktree.gitdir) or ""
        utils.toggle_term_cmd("lazygit " .. flags)
      end,
      desc = "ToggleTerm lazygit",
    }
    maps.n["<leader>tl"] = maps.n["<leader>gg"]
  end
  maps.n["<leader>tf"] = { "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" }
  maps.n["<leader>th"] = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal split" }
  maps.n["<leader>tv"] = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical split" }
  maps.n["<F7>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" }
  maps.t["<F7>"] = maps.n["<F7>"]
end

if is_available "nvim-dap" then
  maps.n["<leader>d"] = sections.d
  maps.v["<leader>d"] = sections.d
  -- modified function keys found with `showkey -a` in the terminal to get key code
  -- run `nvim -V3log +quit` and search through the "Terminal info" in the `log` file for the correct keyname
  maps.n["<F5>"] = { function() require("dap").continue() end, desc = "Debugger: Start" }
  maps.n["<F17>"] = { function() require("dap").terminate() end, desc = "Debugger: Stop" } -- Shift+F5
  maps.n["<F21>"] = { -- Shift+F9
    function()
      vim.ui.input({ prompt = "Condition: " }, function(condition)
        if condition then require("dap").set_breakpoint(condition) end
      end)
    end,
    desc = "Debugger: Conditional Breakpoint",
  }
  maps.n["<F29>"] = { function() require("dap").restart_frame() end, desc = "Debugger: Restart" } -- Control+F5
  maps.n["<F6>"] = { function() require("dap").pause() end, desc = "Debugger: Pause" }
  maps.n["<F9>"] = { function() require("dap").toggle_breakpoint() end, desc = "Debugger: Toggle Breakpoint" }
  maps.n["<F10>"] = { function() require("dap").step_over() end, desc = "Debugger: Step Over" }
  maps.n["<F11>"] = { function() require("dap").step_into() end, desc = "Debugger: Step Into" }
  maps.n["<F23>"] = { function() require("dap").step_out() end, desc = "Debugger: Step Out" } -- Shift+F11
  maps.n["<leader>db"] = { function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint (F9)" }
  maps.n["<leader>dB"] = { function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" }
  maps.n["<leader>dc"] = { function() require("dap").continue() end, desc = "Start/Continue (F5)" }
  maps.n["<leader>dC"] = {
    function()
      vim.ui.input({ prompt = "Condition: " }, function(condition)
        if condition then require("dap").set_breakpoint(condition) end
      end)
    end,
    desc = "Conditional Breakpoint (S-F9)",
  }
  maps.n["<leader>di"] = { function() require("dap").step_into() end, desc = "Step Into (F11)" }
  maps.n["<leader>do"] = { function() require("dap").step_over() end, desc = "Step Over (F10)" }
  maps.n["<leader>dO"] = { function() require("dap").step_out() end, desc = "Step Out (S-F11)" }
  maps.n["<leader>dq"] = { function() require("dap").close() end, desc = "Close Session" }
  maps.n["<leader>dQ"] = { function() require("dap").terminate() end, desc = "Terminate Session (S-F5)" }
  maps.n["<leader>dp"] = { function() require("dap").pause() end, desc = "Pause (F6)" }
  maps.n["<leader>dr"] = { function() require("dap").restart_frame() end, desc = "Restart (C-F5)" }
  maps.n["<leader>dR"] = { function() require("dap").repl.toggle() end, desc = "Toggle REPL" }
  maps.n["<leader>ds"] = { function() require("dap").run_to_cursor() end, desc = "Run To Cursor" }

  if is_available "nvim-dap-ui" then
    maps.n["<leader>dE"] = {
      function()
        vim.ui.input({ prompt = "Expression: " }, function(expr)
          if expr then require("dapui").eval(expr, { enter = true }) end
        end)
      end,
      desc = "Evaluate Input",
    }
    maps.v["<leader>dE"] = { function() require("dapui").eval() end, desc = "Evaluate Input" }
    maps.n["<leader>du"] = { function() require("dapui").toggle() end, desc = "Toggle Debugger UI" }
    maps.n["<leader>dh"] = { function() require("dap.ui.widgets").hover() end, desc = "Debugger Hover" }
  end
end

-- Improved Code Folding
if is_available "nvim-ufo" then
  maps.n["zR"] = { function() require("ufo").openAllFolds() end, desc = "Open all folds" }
  maps.n["zM"] = { function() require("ufo").closeAllFolds() end, desc = "Close all folds" }
  maps.n["zr"] = { function() require("ufo").openFoldsExceptKinds() end, desc = "Fold less" }
  maps.n["zm"] = { function() require("ufo").closeFoldsWith() end, desc = "Fold more" }
  maps.n["zp"] = { function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek fold" }
end

maps.n["<leader>r"] = sections.r
if is_available "asyncrun.vim" then
  maps.n["<leader>ra"] = { "<cmd>AsyncRun ", desc = "Run an async command" }
end

maps.n["<leader>u"] = sections.u
-- Custom menu for modification of the user experience
if is_available "nvim-autopairs" then maps.n["<leader>ua"] = { ui.toggle_autopairs, desc = "Toggle autopairs" } end
maps.n["<leader>ub"] = { ui.toggle_background, desc = "Toggle background" }
if is_available "nvim-cmp" then maps.n["<leader>uc"] = { ui.toggle_cmp, desc = "Toggle autocompletion" } end
if is_available "nvim-colorizer.lua" then
  maps.n["<leader>uC"] = { "<cmd>ColorizerToggle<cr>", desc = "Toggle color highlighting" }
end
maps.n["<leader>uc"] = {
  function() vim.o.cursorcolumn = not vim.o.cursorcolumn end,
  desc = "Toggle cursor column"
}
maps.n["<leader>ud"] = { ui.toggle_diagnostics, desc = "Toggle diagnostics" }
maps.n["<leader>ug"] = { ui.toggle_signcolumn, desc = "Toggle signcolumn" }
maps.n["<leader>ui"] = { ui.set_indent, desc = "Change indent setting" }
maps.n["<leader>ul"] = { ui.toggle_statusline, desc = "Toggle statusline" }
maps.n["<leader>uL"] = { ui.toggle_codelens, desc = "Toggle CodeLens" }
maps.n["<leader>un"] = { ui.change_number, desc = "Change line numbering" }
maps.n["<leader>uN"] = { ui.toggle_ui_notifications, desc = "Toggle Notifications" }
maps.n["<leader>up"] = { ui.toggle_paste, desc = "Toggle paste mode" }
maps.n["<leader>us"] = { ui.toggle_spell, desc = "Toggle spellcheck" }
maps.n["<leader>uS"] = { ui.toggle_conceal, desc = "Toggle conceal" }
maps.n["<leader>ut"] = { ui.toggle_tabline, desc = "Toggle tabline" }
maps.n["<leader>uw"] = { ui.toggle_wrap, desc = "Toggle wrap" }
maps.n["<leader>uy"] = { ui.toggle_syntax, desc = "Toggle syntax highlighting (buffer)" }
maps.n["<leader>uh"] = { ui.toggle_foldcolumn, desc = "Toggle foldcolumn" }

utils.set_mappings(maps)
