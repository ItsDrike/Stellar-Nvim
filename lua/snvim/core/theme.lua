local utils = require "snvim.utils.core"
local settings = require "snvim.utils.settings"

local config = settings.get_settings("theme")

vim.opt.cursorline = config.show_cursor_line
vim.opt.number = config.show_line_numbers
vim.opt.relativenumber = config.show_relative_numbers
vim.opt.showmatch = config.show_matching_brackets
vim.opt.scrolloff = config.horizontal_scrolloff
vim.opt.sidescrolloff = config.vertical_scrolloff
vim.opt.wrap = config.enable_line_wrapping
vim.opt.showmode = config.show_mode
vim.opt.list = true
vim.opt.listchars = config.listchars
vim.g.markdown_fenced_languages = config.markdown_fenced_languages

-- Make sure to utilize the full 256 colors of most modern terminals,
-- if we have $DISPLAY env variable set (we're in a graphical session, not pure TTY)
vim.opt.termguicolors = os.getenv("DISPLAY") and true or false

-- Set highlight colors for cursor line background and current line number foreground
utils.define_augroup(
    "_cursor_color",
    {
        {
            "ColorScheme",
            "*",
            "highlight CursorLine guibg=" .. config.cursor_line_guibg ..
                " ctermbg=" .. config.cursor_line_ctermbg
        },
        {
            "ColorScheme",
            "*",
            "highlight CursorLineNr guifg=" .. config.cursor_line_number_guifg ..
                " ctermfg=" .. config.cursor_line_number_ctermfg
        }
    }
)

-- Set the colorscheme last, since it also triggers the ColorScheme autocmds,
-- which are defined above
vim.cmd("colorscheme " .. config.colorscheme)
