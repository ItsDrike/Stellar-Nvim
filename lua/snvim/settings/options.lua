local path = require "snvim.utils.path"

local M = {}

M.config = {
    default_options = {
        -- Tab/Indent settings
        autoindent = true,      -- Enabel automatic indentation
        expandtab = true,       -- Expand tabs to spaces
        shiftwidth = 4,         -- Indentation size for >/< cmds (should be divisible by tabstop)
        tabstop = 4,            -- Tab character size in spaces
        softtabstop = 4,        -- Autoconvert X spaces into tabs if expandtab=false

        -- Split order
        splitbelow = true,      -- Put new windows below current
        splitright = true,      -- Put new vertical splits to right

        -- In-file search (/)
        ignorecase = true,      -- Use case insensitive matchig
        smartcase = true,       -- Disable ignorecase option if pattern contains uppercase
        hlsearch = true,        -- Highlight all matches on search pattern

        -- Undo/History
        history = 1000,                                         -- Remember more history (previous commands)
        undolevels = 999,                                       -- Remember more undos
        undofile = true,                                        -- Enable persistent undos
        swapfile = true,                                        -- Store changes in swap file for work recovery
        undodir = path.join_paths(Snvim.cache_dir, "undo"),     -- Keep persistent undo files in a directory
        shadafile = path.join_paths(Snvim.cache_dir, "shada"),  -- Shared Data file for info about previous session

        -- Misc
        mouse = "a",                -- Allow mouse to be used
        clipboard = "unnamedplus",  -- Use system clipboard
        autoread = true,            -- Automatically reload files on change
        hidden = true,              -- When switching to another tab, don't unload the previous, just hide it
        updatetime = 300,           -- Faster completion
        timeoutlen = 250,           -- Time in miliseconds to wait for mapped sequence to complete
        fileencoding = "utf-8",     -- The encoding used to write to files
        conceallevel = 0,           -- Make `` visible in markdown
        cmdheight = 2,              -- More space in the neovim command line for displaying messages
        spellfile = path.join_paths(Snvim.config_dir, "spell", "en.utf-8.add")
    },
    append_options = {
        shortmess = {
            "c",    -- Don't show redundant messages from ins-completion-menu
            "I",    -- Don't show the default intro message
        },
        whichwrap = "<,>,[,],h,l"
    },
    headless_options = {
        shortmess = "",     -- Try to prevent echom from cutting messages off or prompting
        more = false,       -- Don't pause listing when screen is filled
        cmdheight = 9999,   -- Helps avoiding |hit-enter| prompts
        columns = 9999,     -- Set the widest screen possible
        swapfile = false,   -- Don't use a swap file
    }
}

return M
