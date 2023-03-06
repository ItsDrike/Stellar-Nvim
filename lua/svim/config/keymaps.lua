-- This file is automatically loaded by lazyvim.plugins.config

local Util = require("lazy.core.util")
local Plugin = require("svim.utils.plugins")

---@param mode string|string[]
---@param lhs string
---@param rhs string
---@param opts table
local function map(mode, lhs, rhs, opts)
  if type(mode) == "string" then
    mode = { mode }
  end

  opts = opts or {}
  opts.silent = opts.silent ~= false

  local keys = {}
  ---@cast keys LazyKeysHandler

  local status_ok, handler = pcall(require, "lazy.core.handler")
  if status_ok then
    keys = handler.handlers.keys
  end

  for _, curmode in ipairs(mode) do
    -- do not create the keymap if a lazy keys handler exists
    if not keys.active[keys.parse({ lhs, mode = curmode }).id] then
      vim.keymap.set(mode, lhs, rhs, opts)
    else
      Util.error("Keymap already defined for " .. lhs .. " on mode " .. curmode, { title = "StellarNvim" })
    end
  end
end

-- Modes:
-- i: insert
-- n: normal
-- t: term
-- v: visual
-- x: visual_block
-- c: command
-- o: operator_pending

-- Move current line / block with Alt-j/k ala vscode.
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move current line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move current line up" })
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move current line down" })
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move current line up" })
map("x", "<A-j>", ":m '>+1<CR>gv=gv'", { desc = "Move current line down" })
map("x", "<A-k>", ":m '<-2<CR>gv=gv'", { desc = "Move current line up" })
map("x", "J", ":m '>+1<CR>gv=gv'", { desc = "Move current line down" })
map("x", "K", ":m '<-2<CR>gv=gv'", { desc = "Move current line up" })

-- Window movement
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows with Ctrl + arrow keys
map("n", "<C-Up>", ":resize -2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", ":resize +2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Better indenting (keep the line selected after indenting)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Common shortcuts
map("n", "<C-s>", ":w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc>:w<CR>i", { desc = "Save file" })
map("n", "<C-z>", ":undo<CR>", { desc = "Undo" })
map("n", "<C-y>", ":redo<CR>", { desc = "Redo" })

-- Keep the cursor in the middle for half page jumps
map("n", "<C-d>", "<C-d>zz", { desc = "Jump half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Jump half page up" })

-- Keep cursor in the middle when searching
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Horizontal movements
map("n", "H", "^")
map("n", "L", "$")

-- Delete to void register
map({"n", "v"}, "<A-d>", '"_d')
map("v", "<A-p>", '"_p')

-- Remove highlight
map({ "i", "n" }, "<Esc><Esc>", "<cmd>nohlsearch<CR><esc>", { desc = "Escape and clear hlsearch" })

-- Quick word replacing (allowing . for next word replace)
map("n", "cn", "*``cgn")
map("n", "cN", "*``cgN")

-- Better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Buffers
if Plugin.has("bufferline.nvim") then
  map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
  map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
else
  map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
  map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
end
map("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<CR>", { desc = "Switch to Other Buffer" })

-- Lazy plugin
map("n", "<leader>l", "<cmd>:Lazy<CR>", { desc = "Lazy" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })
