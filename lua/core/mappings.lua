local M = {}

local utils = require "core.utils"

local map = vim.keymap.set
local cmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Remap space as leader key
map("", "<Space>", "<Nop>")
vim.g.mapleader = " "

-- Normal --
if utils.is_available "smart-splits.nvim" then
  -- Better window navigation
  map("n", "<C-h>", function()
    require("smart-splits").move_cursor_left()
  end)
  map("n", "<C-j>", function()
    require("smart-splits").move_cursor_down()
  end)
  map("n", "<C-k>", function()
    require("smart-splits").move_cursor_up()
  end)
  map("n", "<C-l>", function()
    require("smart-splits").move_cursor_right()
  end)

  -- Resize with arrows
  map("n", "<C-Up>", function()
    require("smart-splits").resize_up()
  end)
  map("n", "<C-Down>", function()
    require("smart-splits").resize_down()
  end)
  map("n", "<C-Left>", function()
    require("smart-splits").resize_left()
  end)
  map("n", "<C-Right>", function()
    require("smart-splits").resize_right()
  end)
end

-- Function Keys
map("n", "<F2>", function()
  utils.set_cwd_to_current_file()
end)

-- Buffers
map("n", "[b", "<cmd>bprevious<CR>")
map("n", "]b", "<cmd>bnext<CR>")
map("n", "[B", "<cmd>bfirst<CR>")
map("n", "]B", "<cmd>blast<CR>")

-- Quickfix
map("n", "[c", "<cmd>cprevious<CR>")
map("n", "]c", "<cmd>cnext<CR>")
map("n", "[C", "<cmd>cfirst<CR>")
map("n", "]C", "<cmd>clast<CR>")

-- Location
map("n", "[l", "<cmd>lprevious<CR>")
map("n", "]l", "<cmd>lnext<CR>")
map("n", "[L", "<cmd>lfirst<CR>")
map("n", "]L", "<cmd>llast<CR>")

-- Tag
map("n", "[t", "<cmd>tprevious<CR>")
map("n", "]t", "<cmd>tnext<CR>")
map("n", "[T", "<cmd>tfirst<CR>")
map("n", "]T", "<cmd>tlast<CR>")

-- Preview tag
map("n", "[r", "<cmd>ptprevious<CR>")
map("n", "]r", "<cmd>ptnext<CR>")
map("n", "[R", "<cmd>ptfirst<CR>")
map("n", "]R", "<cmd>ptlast<CR>")

-- LSP
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)

-- Registers
map("n", "<leader>p", '"+')
map("v", "<leader>p", '"+')
map("n", "<leader>o", '"_')
map("v", "<leader>o", '"_')

-- Comment
if utils.is_available "Comment.nvim" then
  map("v", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>")
end

-- EasyMotion
if utils.is_available "vim-easymotion" then
  map("n", "<leader>m", "<Plug>(easymotion-prefix)")
end

return M
