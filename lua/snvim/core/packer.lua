local path = require "snvim.utils.path"
local settings = require "snvim.utils.settings"

local M = {}


-- Download and load packer plugin manager (will reinstall if packer is already present)
--@param install_path string @Path to packer plugin directory
function M.bootstrap_packer(install_path)
    if path.is_directory(install_path) then
        print("Packer is already present - reinstalling, please wait...")
        vim.fn.delete(install_path, "rf")
    else
        print("Clonning pakcer plugin manager, please wait...")
    end

    vim.fn.system({
        "git", "clone", "--depth", "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path
    })
    -- Add packer plugin via nvim's internal plugin system
    vim.cmd("packadd packer.nvim")

    -- Make sure packer works
    local present, packer = pcall(require, "packer")
    if present then
        print("Packer clonned successfully.")
        return true
    else
        print("Couldn't clone packer! Packer path: " .. install_path .. "\n" .. packer)
        return false
    end
end

-- Initialize packer
--@param snvim Snvim
function M.init()
    local packer = require "packer"
    local packer_settings = settings.get_settings("packer")
    packer.init(packer_settings)
end

-- Load all specified plugins
--@param plugin_list table
function M.load_plugins(plugin_list)
    local packer = require "packer"
    packer.startup(function(use)
        -- Use all specified plugins
        for _, plugin in ipairs(plugin_list) do
            use(plugin)
        end
    end)
end

return M
