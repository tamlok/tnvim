local M = {}

local utils = require "core.utils"

local status_ok, which_key = pcall(require, "which-key")
if status_ok then
  local opts = {
    mode = "n",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
  }

  local mappings = {
    ["."] = { '<cmd>"+yiw<CR>', "Yank the word under cursor to clipboard" },

    -- Tabs
    ["0"] = {
      function()
        vim.cmd("tabn " .. vim.g.t_last_active_tab)
      end,
      "Alternate between current and last active tab"
    },
    ["1"] = { "<esc>1gt", "Go to tab 1" },
    ["2"] = { "<esc>2gt", "Go to tab 2" },
    ["3"] = { "<esc>3gt", "Go to tab 3" },
    ["4"] = { "<esc>4gt", "Go to tab 4" },
    ["5"] = { "<esc>5gt", "Go to tab 5" },
    ["6"] = { "<esc>6gt", "Go to tab 6" },
    ["7"] = { "<esc>7gt", "Go to tab 7" },
    ["8"] = { "<esc>8gt", "Go to tab 8" },
    ["9"] = { "<esc>9gt", "Go to tab 9" },

    ["v"] = { "V`", "Select just pasted text" },

    a = {
      name = "Async Run/Async Task"
    },

    b = {
      name = "Buffer",
    },

    f = {
      name = "Fuzzy Search",
    },

    g = {
      name = "Git",
    },

    h = {
      name = "Highlight",
      h = { "<cmd>nohlsearch<CR>", "No Highlight" },
      i = { "<cmd>ClangdSwitchSourceHeader<CR>", "Switch between heder and implementation file" }
    },

    l = {
      name = "LSP",
      a = { vim.lsp.buf.code_action, "Code Action" },
      o = { vim.diagnostic.open_float, "Hover Diagnostic" },
      q = { vim.diagnostic.hide, "Hide Diagnostic" },
      f = { vim.lsp.buf.formatting_sync, "Format" },
      D = { vim.lsp.buf.declaration, "Go to declaration" },
      d = { vim.lsp.buf.definition, "Go to definition" },
      i = { vim.lsp.buf.implementation, "Go to implementation" },
      r = { vim.lsp.buf.references, "List all references" },
      R = { vim.lsp.buf.rename, "Rename" },
      h = { vim.lsp.buf.hover, "Display hover information" },
    },

    -- o = {}
    -- p = {}

    s = {
      name = "Session/External Search",
      s = { "<cmd>SessionLoad<CR>", "Save Session" },
      l = { "<cmd>SessionSave<CR>", "Load Session" },
    },

    t = {
      name = "Tree/Tag/Terminal",
    },

    w = {
      name = "Windows",
      w = { "<cmd>w<CR>", "Write Buffer" },
      q = { "<cmd>q<CR>", "Quit" },
      t = { "<cmd>tabedit<CR>", "Open a new tab" },
      z = { utils.zoom_restore_current_window , "Zoom/Restore current window" },
      h = {
        function()
          vim.o.cursorcolumn = not vim.o.cursorcolumn
        end,
        "Zoom/Restore current window"
      },
    },

    x = {
      name = "Toggle",
      c = {
        function()
          local beforeCnt = vim.call("winnr", "$")
          vim.cmd("copen")
          if beforeCnt == vim.call("winnr", "$") then
            vim.cmd("cclose")
          end
        end,
        "Toggle quickfix list"
      },
      l = {
        function()
          local beforeCnt = vim.call("winnr", "$")
          vim.cmd("lopen")
          if beforeCnt == vim.call("winnr", "$") then
            vim.cmd("lclose")
          end
        end,
        "Toggle location list"
      },
      t = { "<cmd>tabclose<CR>", "Close tab" },
    },
  }

  if utils.is_available "nerdtree" then
    mappings.t.r = { "<cmd>NERDTreeToggle<CR>", "Toggle File Explorer" }
    mappings.t.f = { "<cmd>NERDTreeFind<CR>", "Toggle File Explorer" }
  end

  if utils.is_available "open-browser.vim" then
    mappings.s.c = { "<cmd>call openbrowser#smart_search(expand('<cword>'), 'cplusplus')<CR>",
                     "Search word under cursor in CPlusPlus" }
    mappings.s.q = { "<cmd>call openbrowser#smart_search(expand('<cword>'), 'qt')<CR>",
                     "Search word under cursor in Qt docs" }
  end

  if utils.is_available "symbols-outline.nvim" then
    mappings.t.s = { "<cmd>SymbolsOutline<CR>", "Toggle Symbols Outline" }
  end

  if utils.is_available "Comment.nvim" then
    mappings["/"] = {
      function()
        require("Comment.api").toggle_current_linewise()
      end,
      "Comment",
    }
  end

  if utils.is_available "vim-bbye" then
    mappings.b.c = { "<cmd>Bdelete!<CR>", "Close Buffer" }
  end

  if utils.is_available "gitsigns.nvim" then
    mappings.g.j = {
      function()
        require("gitsigns").next_hunk()
      end,
      "Next Hunk",
    }
    mappings.g.k = {
      function()
        require("gitsigns").prev_hunk()
      end,
      "Prev Hunk",
    }
    mappings.g.l = {
      function()
        require("gitsigns").blame_line()
      end,
      "Blame",
    }
    mappings.g.p = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Preview Hunk",
    }
    mappings.g.h = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset Hunk",
    }
    mappings.g.r = {
      function()
        require("gitsigns").reset_buffer()
      end,
      "Reset Buffer",
    }
    mappings.g.s = {
      function()
        require("gitsigns").stage_hunk()
      end,
      "Stage Hunk",
    }
    mappings.g.u = {
      function()
        require("gitsigns").undo_stage_hunk()
      end,
      "Undo Stage Hunk",
    }
    mappings.g.d = {
      function()
        require("gitsigns").diffthis()
      end,
      "Diff",
    }
  end

  if utils.is_available "diffview.nvim" then
      mappings.g.v = { "<cmd>DiffviewOpen<CR>", "Git diff view" }
      mappings.g.f = { "<cmd>DiffviewFocusFiles<CR>", "Focus the files panel of diff view" }
      mappings.g.y = { "<cmd>DiffviewFileHistory %<CR>", "View history of current buffer" }
  end

  if utils.is_available "nvim-toggleterm.lua" then
    -- Add common commands here.
    mappings.t.t = { "<cmd>ToggleTerm<CR>", "Toggle Terminal" }
    mappings.t.h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" }
    mappings.t.v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" }
  end

  if utils.is_available "symbols-outline.nvim" then
    mappings.l.s = { "<cmd>SymbolsOutline<CR>", "Symbols Outline" }
  end

  if utils.is_available "asyncrun.vim" then
    vim.cmd("nnoremap <leader>aa :AsyncRun ")
    mappings.a.a = { "Async run a command" }
  end

  if utils.is_available "asynctasks.vim" then
    mappings.a.b = { "<cmd>AsyncTask build<cr>", "Async run task 'build'" }
    mappings.a.r = { "<cmd>AsyncTask run<cr>", "Async run task 'run'" }
  end

  if utils.is_available "telescope.nvim" then
    mappings.f.f = {
      function()
        require("configs.telescope").find_files_in_dirs({previewer = false})
      end,
      "Fuzzy search for files"
    }
    mappings.f.b = {
      function()
        require("telescope.builtin").buffers()
      end,
      "Fuzzy search for buffers"
    }
    mappings.f.m = {
      function()
        require("telescope.builtin").oldfiles({previewer = false})
      end,
      "Fuzzy search for recently opened files"
    }
    mappings.f.u = {
      "<cmd>Telescope ctags_outline outline<CR>",
      "Fuzzy search for a tag within current buffer"
    }
    mappings.f.a = {
      function()
        require('telescope').extensions.ctags_outline.outline({buf='all'})
      end,
      "Fuzzy search for a tag within opened buffers"
    }
    mappings.f.e = {
      function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols()
      end,
      "Fuzzy search for a tag in all workspaces"
    }
    mappings.f.g = {
      function()
        require("telescope.builtin").live_grep({grep_open_files = true})
      end,
      "Fuzzy search within opened buffers" ,
    }
  elseif utils.is_available "LeaderF" then
    mappings.f.f = { "Fuzzy search for files" }
    mappings.f.b = { "Fuzzy search for buffers" }
    mappings.f.c = {
      function()
        vim.cmd('LeaderfFile ' .. utils.get_cwd())
      end,
      "Fuzzy search for files in current working directoy" }
    mappings.f.m = { "<cmd>LeaderfMru<CR>", "Fuzzy search for MRU files" }
    mappings.f.t = { "<cmd>LeaderfTag<CR>", "Fuzzy search for a tag in tag files" }
    mappings.f.u = { "<cmd>LeaderfBufTag<CR>", "Fuzzy search for a tag within current buffer" }
    mappings.f.a = { "<cmd>LeaderfBufTagAll<CR>", "Fuzzy search for a tag within buffers" }
    mappings.f.i = { "<cmd>LeaderfFunction<CR>", "Fuzzy search for a function within current buffer" }
    mappings.f.e = { "<cmd>LeaderfFunctionAll<CR>", "Fuzzy search for a function within buffers" }

    mappings.f.w = {}
    mappings.f.w.u = { "<cmd>LeaderfBufTagCword<CR>", "Fuzzy search for a tag within current buffer using word under cursor" }
    mappings.f.w.a = { "<cmd>LeaderfBufTagAllCword<CR>", "Fuzzy search for a tag within buffers using word under cursor" }
    mappings.f.w.n = { "<cmd>LeaderfFunctionCword<CR>", "Fuzzy search for a function within current buffer using word under cursor" }
    mappings.f.w.e = { "<cmd>LeaderfFunctionAllCword<CR>", "Fuzzy search for a function within buffers using word under cursor" }

    mappings.f.l = { "<cmd>LeaderfFile --recall<CR>", "Recall last fuzzy search" }

    mappings.f.r = {
      function()
        vim.cmd('Leaderf! gtags -r "' .. utils.get_cword() .. '" --auto-jump')
      end,
      "Gtags jump to references of the word under cursor" }
    mappings.f.d = {
      function()
        vim.cmd('Leaderf! gtags -d "' .. utils.get_cword() .. '" --auto-jump')
      end,
      "Gtags jump to definition of the word under cursor" }

    vim.cmd("nnoremap <leader>fh :Leaderf! gtags -d --auto-jump ")
    mappings.f.h = { "Gtags jump to definition" }
    mappings.f.o = { "<cmd>Leaderf! gtags --recall<CR>", "Recall last Gtags search" }
    mappings.f.n = { "<cmd>Leaderf! gtags --next<CR>", "Jump to next Gtags search result" }
    mappings.f.p = { "<cmd>Leaderf! gtags --previous<CR>", "Jump to previous Gtags search result" }

    mappings.f.g = {}

    vim.cmd("nnoremap <leader>fgs :Leaderf! rg -e ")
    mappings.f.g.s = { "Grep words in files" }

    vim.cmd("nnoremap <leader>fgc :Leaderf! rg -t cpp -e ")
    mappings.f.g.c = { "Grep words in CPP files" }

    mappings.f.g.t = {
      function()
        vim.cmd('Leaderf! rg -e "' .. utils.get_cword() .. '"')
      end,
      "Grep the word under cursor in files"
    }

    mappings.f.g.d = {
      function()
        vim.cmd('Leaderf! rg -t cpp -e "' .. utils.get_cword() .. '"')
      end,
      "Grep the word under cursor in CPP files"
    }
  end

  mappings.f.s = {}
  if utils.is_available "ack.vim" then
    vim.cmd("nnoremap <leader>fss :TVAck ")
    mappings.f.s.s = { "Grep words in files" }

    vim.cmd("nnoremap <leader>fsc :TVAck --type=cpp ")
    mappings.f.s.c = { "Grep words in CPP files" }
  end

  which_key.register(require("core.utils").user_plugin_opts("which-key.register_n_leader", mappings), opts)
end

return M
