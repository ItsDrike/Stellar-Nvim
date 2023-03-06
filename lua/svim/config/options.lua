-- This file is automatically loaded by lazyvim.plugins.config

local Path = require("svim.utils.path")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.backup = false -- creates a backup file
opt.clipboard = "unnamedplus" -- use system clipboard for yank/paste
opt.completeopt = { "menuone", "noselect" }
opt.conceallevel = 3 -- hide * markup for bold and italic
opt.confirm = true -- confirm to save changes before exiting modified buffer
opt.cursorline = true -- enable highlighting of the current line
opt.expandtab = true -- use spaces instead of tabs
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.foldexpr = "" -- set to nvim_treesitter#foldexpr() for treesitter based folding
opt.foldmethod = "manual" -- set to "expr" for treesitter based folding
opt.guifont = "monospace:h17" -- the font used in graphical neovim applications
opt.hidden = true -- required to keep multiple buffers and open multiple buffers
opt.hlsearch = true -- highlight all matches on previous search pattern
opt.ignorecase = true -- ignore case in search patterns
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 3
opt.list = true -- show some invisible characters (tabs...)
opt.listchars = { tab = " ", trail = "·" } -- specify what chars to show and with what symbols
opt.mouse = "a" -- allow the mouse to be used in neovim
opt.number = true -- show line numbers
opt.numberwidth = 4 -- set number column width (default 4)
opt.pnumheight = 10 -- popup menu height
opt.relativenumber = true -- relative line numbers
opt.ruler = false
opt.scrolloff = 8 -- minimal number of screen lines to keep above and below the cursor
opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
opt.showcmd = false
opt.showmode = false -- we don't need to see things like -- INSERT -- (we have a bar for that)
opt.sidescrolloff = 8 -- minimal number of screen characters to keep left and right of the cursor
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" } -- what to store in a session (:mksession)
opt.shiftround = true -- always round indent to multiple of shiftwidth when indenting (>>, <<)
opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
opt.smartcase = true -- override ignorecase if search pattern contains upper case chars
opt.smartindent = true -- insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- force all horizontal splits to go below current window
opt.splitright = true -- force all vertical splits to go to the right of current window
opt.swapfile = false -- creates a swapfile
opt.tabstop = 2 -- insert 2 spaces for a tab character
opt.termguicolors = true -- set term gui colors (most terminal support this)
opt.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
opt.title = true -- set the title of window to the value of the titlestring
-- opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to
opt.undodir = Path.undodir
opt.undofile = true -- enable persistent undo (undos will be stored in undodir)
opt.undolevels = 10000 -- maximum number of changes that can be undone (undo data is kept in memory)
opt.updatetime = 200 -- write file to disk if it wasn't written to after this many milliseconds, also triggers CursorHold
opt.wildmode = "longest:full,full" -- command line completion mode
opt.winminwidth = 5 -- minimum window width
opt.wrap = false -- display lines as one long line, going outside of the window
opt.writebackup = false -- if a file is being edited by another program (or was written to, while editing with another program), it is not allowed to be edited

opt.formatoptions = {
  -- default: tcqj
  t = true, -- Auto-wrap text using 'textwidth'
  c = true, -- Auto-wrap comments using 'textwidth', inserting the comment leader automatically
  r = false, -- Automatically insert the comment leader after hitting <Enter> in Insert mode
  o = false, -- Automatically insert the comment leader after hitting 'o' or 'O' in Normal mode
  q = true, -- Allow formatting of comments with "gq" (won't change blank lines)
  w = false, -- Trailing whitespace continues paragraph in the next line, non-whitespace ends it
  a = false, -- Automatic formatting of paragraph. Every time text is inserted/deleted, paragraph gets reformatted
  n = false, -- Recognize numbered lists when wrapping.
  ["2"] = true, -- Use indent from 2nd line of a paragraph
  v = false, -- Only break a line at a blank entered during current insert command
  b = false, -- Like 'v', but only wrap on entering blank, or before the wrap margin
  l = false, -- Long lines are not broken in insert mode
  m = false, -- Also break at a multibyte character above 255
  M = false, -- When joining lines, don't insert a space before, or after two multibyte chars (overruled by 'B')
  B = false, -- When joining lines, don't insert a space between two multibyte chars (overruled by 'M')
  ["1"] = true, -- Break line before a single-letter word.
  ["]"] = false, -- Respect 'textwidth' rigorously, no line can be longer unless there's some except rule
  j = true, -- Remove comment leader when joining lines, when it makes sense
  p = false, -- Don't break lines at single spaces that follow periods (such as for Surely you're joking, Mr. Feynman!)
}

opt.shortmess = {
  -- default: filnxtToOF
  f = true, -- use "(3 of 5)" instead of "(file 3 of 5)"
  i = true, -- use "[noeol]" instead of "[Incomplete last line]"
  l = true, -- use "999L, 888B" instead of "999 lines, 888 bytes"
  m = false, -- use "[+]" instead of "[Modified]"
  n = true, -- use "[New]" instead of "[New File]"
  r = false, -- use "[RO]" instead of "[readonly]"
  w = false, -- use "[w]" instead of "written" for file write message
  x = true, -- use "[dos]" instead of "[dos format]", "[unix]"
  a = false, -- all of the above abbreviations
  o = true, -- overwrite message for writing a file with subsequent message for reading a file (useful for ":wn" or when 'autowrite' on)
  O = true, -- message for reading a file overwrites any previous message; also for quickfix message (e.g. ":cn")
  s = false, -- don't give "search hit BOTTOM, continuing at TOP" (or vice versa) messages; when using the search count do not show "W" after the count message (see S below)
  t = true, -- truncate file message at the start if it is too long
  T = true, -- truncate other messages in the middle if they are too long to fit on the command line, "<" will appear in the left most column
  W = false, -- don't give "written" or "[w]" when writing a file
  A = false, -- don't give the "ATTENTION" message when existing swap file is found
  I = true, -- don't give the intro message when starting Vim (see :intro)
  c = false, -- don't give the ins-completion-menu messages; for example, "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found", "Back at original", etc.
  C = false, -- don't give messages while scanning for ins-completion items, for instance "scanning tags"
  q = false, -- use "recording" instead of "recording @a"
  F = false, -- don't give the file info when editing a file, like :silent was used in command
  S = false, -- do not show search count message when searching, e.g. "[1/5]"
}

-- Prefer ripgrep if available
if vim.fn.executable("rg") == 1 then
  opt.grepformat = "%f:%l:%c:%m"
  opt.grepprg = "rg --vimgrep"
end

if vim.fn.has("nvim-0.9.0") == 1 then
  opt.splitkeep = "screen"
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
