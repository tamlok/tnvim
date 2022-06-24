local M = {}

local packer_status_ok, packer = pcall(require, "packer")
if packer_status_ok then
  local utils = require "core.utils"
  local config = utils.user_settings()

  local plugins = {
    -- Plugin manager
    {
      "wbthomason/packer.nvim",
    },

    -- Colorschemes
    {
      "sainnhe/edge",
      config = function()
        vim.o.background = 'light'
        vim.g.edge_style = 'default'
        vim.g.edge_better_performance = true
        vim.cmd "colorscheme edge"
      end,
      disable = false,
    },

    {
      "EdenEast/nightfox.nvim",
      config = function()
        vim.o.background = 'light'
        vim.cmd "colorscheme dawnfox"
      end,
      disable = true,
    },

    -- Optimiser
    { "lewis6991/impatient.nvim" },

    { "nathom/filetype.nvim",
      config = function()
        require("configs.filetype").config()
      end,
    },

    -- Lua functions
    { "nvim-lua/plenary.nvim" },

    -- Popup API
    { "nvim-lua/popup.nvim" },

    -- Indent detection
    {
      "Darazaki/indent-o-matic",
      event = "BufRead",
      config = function()
        require("configs.indent-o-matic").config()
      end,
    },

    -- Notification Enhancer
    {
      "rcarriga/nvim-notify",
      config = function()
        require("configs.notify").config()
      end,
    },

    -- Neovim UI Enhancer
    {
      "MunifTanjim/nui.nvim",
      module = "nui",
    },

    -- Cursorhold fix
    {
      "antoinemadec/FixCursorHold.nvim",
      event = { "BufRead", "BufNewFile" },
      config = function()
        vim.g.cursorhold_updatetime = 100
      end,
    },

    -- Smarter Splits
    {
      "mrjones2014/smart-splits.nvim",
      module = "smart-splits",
      config = function()
        require("configs.smart-splits").config()
      end,
    },

    -- Icons
    {
      "kyazdani42/nvim-web-devicons",
      config = function()
        require("configs.icons").config()
      end,
    },

    -- Bufferline
    {
      "akinsho/bufferline.nvim",
      after = "nvim-web-devicons",
      config = function()
        require("configs.bufferline").config()
      end,
      disable = not config.enabled.bufferline,
    },

    -- Better buffer closing
    {
      "moll/vim-bbye",
    },

    -- File explorer
    {
      "preservim/nerdtree",
      cmd = {"NERDTree", "NERDTreeToggle", "NERDTreeFind"},
      config = function()
        require("configs.nerdtree").config()
      end,
    },

    -- Statusline
    {
      "nvim-lualine/lualine.nvim",
      config = function()
        require("configs.lualine").config()
      end,
      disable = not config.enabled.lualine,
    },

    -- Parenthesis highlighting
    {
      "p00f/nvim-ts-rainbow",
      after = "nvim-treesitter",
      disable = not config.enabled.ts_rainbow,
    },

    -- Autoclose tags
    {
      "windwp/nvim-ts-autotag",
      after = "nvim-treesitter",
      disable = not config.enabled.ts_autotag,
    },

    -- Context based commenting
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      after = "nvim-treesitter",
    },

    -- Syntax highlighting
    {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      event = { "BufRead", "BufNewFile" },
      cmd = {
        "TSInstall",
        "TSInstallInfo",
        "TSInstallSync",
        "TSUninstall",
        "TSUpdate",
        "TSUpdateSync",
        "TSDisableAll",
        "TSEnableAll",
      },
      config = function()
        require("configs.treesitter").config()
      end,
    },

    -- Completion engine
    {
      "hrsh7th/nvim-cmp",
      config = function()
        require("configs.cmp").config()
      end,
    },

    -- Buffer completion source
    {
      "hrsh7th/cmp-buffer",
      after = "nvim-cmp",
      config = function()
        require("core.utils").add_user_cmp_source "buffer"
      end,
    },

    -- Path completion source
    {
      "hrsh7th/cmp-path",
      after = "nvim-cmp",
      config = function()
        require("core.utils").add_user_cmp_source "path"
      end,
    },

    -- LSP completion source
    {
      "hrsh7th/cmp-nvim-lsp",
      after = "nvim-cmp",
      config = function()
        require("core.utils").add_user_cmp_source "nvim_lsp"
      end,
    },

    -- LSP manager
    {
      "williamboman/nvim-lsp-installer",
      module = "nvim-lsp-installer",
      cmd = {
        "LspInstall",
        "LspInstallInfo",
        "LspPrintInstalled",
        "LspRestart",
        "LspStart",
        "LspStop",
        "LspUninstall",
        "LspUninstallAll",
      },
    },

    -- Built-in LSP
    {
      "neovim/nvim-lspconfig",
      tag = "v0.1.3",
      event = "BufWinEnter",
      config = function()
        require "configs.lsp"
      end,
    },

    -- LSP symbols
    {
      "simrat39/symbols-outline.nvim",
      cmd = "SymbolsOutline",
      setup = function()
        require("configs.symbols-outline").setup()
      end,
    },

    -- Formatting and linting
    {
      "jose-elias-alvarez/null-ls.nvim",
      event = { "BufRead", "BufNewFile" },
    },

    -- Git integration
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufRead", "BufNewFile" },
      config = function()
        require("configs.gitsigns").config()
      end,
      disable = not config.enabled.gitsigns,
    },

    -- Color highlighting
    {
      "norcalli/nvim-colorizer.lua",
      event = { "BufRead", "BufNewFile" },
      config = function()
        require("configs.colorizer").config()
      end,
      disable = not config.enabled.colorizer,
    },

    -- Autopairs
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("configs.autopairs").config()
      end,
    },

    -- Terminal
    {
      "akinsho/nvim-toggleterm.lua",
      cmd = "ToggleTerm",
      module = { "toggleterm", "toggleterm.terminal" },
      config = function()
        require("configs.toggleterm").config()
      end,
      disable = not config.enabled.toggle_term,
    },

    -- Keymaps popup
    {
      "folke/which-key.nvim",
      config = function()
        require("configs.which-key").config()
      end,
      disable = not config.enabled.which_key,
    },

    -- Get extra JSON schemas
    { "b0o/SchemaStore.nvim" },

    -- Easy movement
    { "easymotion/vim-easymotion" },

    -- File search, tag search and more
    {
      "Yggdroot/LeaderF",
      run = ":LeaderfInstallCExtension",
      config = function()
        require("configs.leaderf").config()
      end,
      disable = config.enabled.telescope,
    },

		-- Fuzzy finder
    {
      "nvim-telescope/telescope.nvim",
			cmd = "Telescope",
			module = "telescope",
			config = function()
				require("configs.telescope").config()
			end,
		},

		-- Fuzzy finder syntax support
		{
      "natecraddock/telescope-zf-native.nvim",
			after = "telescope.nvim",
			config = function()
				require("telescope").load_extension("zf-native")
			end,
		},

    -- Outline using ctags
    {
      "fcying/telescope-ctags-outline.nvim",
			after = "telescope.nvim",
    },

    -- Smooth scrolling
    {
      "psliwka/vim-smoothie",
    },

    -- Async run
    {
      "skywind3000/asyncrun.vim",
      cmd = "AsyncRun",
      config = function()
        require("configs.asyncrun").config()
      end,
    },

    -- Async tasks
    {
      "skywind3000/asynctasks.vim",
      cmd = {
        "AsyncTask",
        "AsyncTaskEdit",
      },
    },

    -- In-place CSS color
    {
      "ap/vim-css-color",
    },

    -- Ack
    {
      "mileszs/ack.vim",
      cmd = "Ack",
      setup = function()
        require("configs.ack").setup()
      end,
      config = function()
        require("configs.ack").config()
      end,
    },

    -- Open Browser
    {
      "tyru/open-browser.vim",
      config = function()
        require("configs.open-browser").config()
      end,
    },

    -- Switch Header/Implementation file
    {
      "derekwyatt/vim-fswitch",
      cmd = "FSHere",
    },

    -- CTags and GTags
    {
      "tamlok/vim-gutentags",
      config = function()
        require("configs.vim-gutentags").config()
      end,
      disable = true,
    },

    -- Gtags
    {
      "vim-scripts/gtags.vim",
    },

    -- Vimspector
    {
      "puremourning/vimspector",
      setup = function()
        vim.g.vimspector_enable_mappings = 'VISUAL_STUDIO'
      end,
      disable = true,
    },

    -- Git
    {
      "sindrets/diffview.nvim",
      after = "plenary.nvim",
      config = function()
      end,
    }
  }

  packer.startup {
    function(use)
      -- Load plugins!
      for _, plugin in
        pairs(
          require("core.utils").user_plugin_opts("plugins.init", require("core.utils").label_plugins(plugins))
        )
      do
        use(plugin)
      end
    end,
    config = require("core.utils").user_plugin_opts("plugins.packer", {
      compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
      display = {
        open_fn = function()
          return require("packer.util").float { border = "rounded" }
        end,
      },
      profile = {
        enable = true,
        threshold = 0.0001,
      },
      git = {
        clone_timeout = 300,
        subcommands = {
          update = "pull --ff-only --progress --rebase",
        },
      },
      auto_clean = true,
      compile_on_sync = true,
    }),
  }
end

return M
