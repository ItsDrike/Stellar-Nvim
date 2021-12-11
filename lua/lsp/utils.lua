local vim = require("vim")
local tbl = require("utility.table")

local M = {}

-- Check whether given LSP server (by name) is currently active
function M.is_server_active(server_name)
    local clients = vim.lsp.get_active_clients()
    return tbl.find_first(clients, function(client)
        return client.name == server_name
    end)
end

-- Check if the manager autocmd has already been configured since some servers can take a while to initialize
-- this helps guarding against a data-race condition where a server can get configured twice which seems to occur only when attaching to single-files
function M.is_server_configured(server_name, filetype)
    filetype = filetype or vim.bo.filetype
    local active_autocmds = vim.split(vim.fn.execute("autocmd FileType" .. filetype), "\n")
    for _, result in ipairs(active_autocmds) do
        if result:match(server_name) then
            return true
        end
    end
    return false
end

-- Get a list of supported filetypes from a given language server (by name)
-- This required nvim-lsp-installer plugin
function M.get_supported_filetypes(server_name)
    local lsp_installer_servers = require("nvim-lsp-installer.servers")
    local server_available, requested_server = lsp_installer_servers.get_server(server_name)
    if not server_available then
        return {}
    end
    return requested_server:get_supported_filetypes()
end

return M
