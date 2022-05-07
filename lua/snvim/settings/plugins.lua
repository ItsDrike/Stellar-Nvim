local settings = require "snvim.utils.settings"

local M = {}

M.config = {
    { "wbthomason/packer.nvim" },           -- Let packer manage itself, so it gets updates
    { "Tastyep/structlog.nvim" },           -- Structured logging for nvim

    { "tomasiser/vim-code-dark" },          -- Vim theme inspired by vscode's Dark+
}

return M
