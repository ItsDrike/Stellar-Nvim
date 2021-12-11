local m = require("snvim.utility.mappings")
local vim = require("vim")
local cmd = vim.cmd

-- Set up shortcuts to quickly comment some code
m.keymap("n", "<A-/>", ":Commentary<CR>")
m.keymap("v", "<A-/>", ":Commentary<CR>")

-- Set up comments for unhandled file types
cmd[[autocmd FileType apache setlocal commentstring=#\ %s]]
