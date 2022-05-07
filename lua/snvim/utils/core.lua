local M = {}


-- Create autocommand group
-- @param group_name string @Name of the augroup
-- @param autocmds table @Table of autocmd definitions, these definitions
-- are themselves tables of individual parameters. For example:
-- {{"FileType", "c", "setlocal shiftwidth=2"}, {"FileType", ...}}
-- @param buffer bool @Indivate if the augroup should be local to the buffer (no)
function M.define_augroup(group_name, autocmds, buffer)
    vim.cmd("augroup " .. group_name)

    if buffer then
        vim.cmd [[autocmd! * <buffer>]]
    else
        vim.cmd [[autocmd!]]
    end

    for _, autocmd_def in pairs(autocmds) do
        local command = table.concat(vim.tbl_flatten { "autocmd", autocmd_def }, " ")
        vim.cmd(command)
    end

    vim.cmd "augroup END"
end


-- Disable autocommand group if it exists.
-- This resets the autogroup to a new one with no autocmds. 
-- To reenable the group, we will need to redefine it.
-- (This is more reliable than trying to delete the autogroup itself)
-- @param name string @The autogroup name
function M.remove_autogroup(name)
    -- defer the fucntion in case the autocommand is still in-use
    vim.schedule(function()
        if vim.fn.exists("#" .. name) == 1 then
            vim.cmd("autogroup" .. name)
            vim.cmd "autocmd!"
            vim.cmd "aurogroup END"
        end
    end)
end


-- Define nvim keymapping
-- @param mode "n" | "i" | "v" | "x" | "s" | "o" | "c" | "l" | "t" | "!" | ""
-- @param shortcut string @The key to be mapped
-- @param command string
-- @param options passed to nvim_set_keymap, by default, we pass noremap=true, silent=true
function M.keymap(mode, shortcut, command, options)
    local opts = {noremap=true, silent=true}

    if options then opts = vim.tbl_extend("force", opts, options) end
    vim.api.nvim_set_keymap(mode, shortcut, command, opts)
end


-- Define an nvim abbreviation
-- @param mode "c" | "i" | ""
function M.abbrev(mode, input, result, reabbrev)
    -- TODO: nvim really needs something like vim.api.nvim_set_abbrev
    -- Assume noreabbrev unless specified otherwise
    reabbrev = reabbrev or false
    local command
    if reabbrev then
        command = mode .. "abbrev"
    else
        command = mode .. "noreabbrev"
    end
    vim.cmd(command .. " " .. input .. " " .. result)
end

return M
