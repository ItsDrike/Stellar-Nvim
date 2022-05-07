local settings = require "snvim.utils.settings"
local path = require "snvim.utils.path"

--@class Snvim
local M = {}


-- Try to obtain a path from given environmental variable, if that
-- fails, fallback to given stdpath resolution.
--@param env_var string @Environmental variable to check for the path
--@param stdpath string @Argument to vim.fn.stdpath function to get path
--@returns string
local function get_dir(env_var, stdpath)
    local env_path = os.getenv(env_var)
    if not env_path then
        return vim.fn.stdpath(stdpath)
    end
    return env_path
end


-- Perform a check that ensures neovim installation is at a certain version
-- which this project requires. Otherwise quit nvim with code 1
local function ensure_version()
    if vim.fn.has "nvim-0.6.1" ~= 1 then
        vim.notify("Please upgrade your Neovim base installation. This config requires v0.6.1+", vim.log.levels.WARN)
        vim.wait(5000, function()
            return false
        end)
        vim.cmd "cquit"
    end
end


-- Initialize basic attributes, the `&runtimepath` variable and prepare for startup
--@returns table
function M:init()
    -- Some basic attributes
    self.in_headless = #vim.api.nvim_list_uis() == 0
    self.log_level = self.in_headless and "DEBUG" or "WARN"

    -- Set some path attributes
    self.runtime_dir = get_dir("SNVIM_RUNTIME_DIR", "data")
    self.config_dir = get_dir("SNVIM_CONFIG_DIR", "config")
    self.cache_dir = get_dir("SNVIM_CACHE_DIR", "cache")
    self.pack_dir = path.join_paths(self.runtime_dir, "site", "pack")

    -- Plugin specific paths
    self.packer_install_dir = path.join_paths(self.pack_dir, "packer", "start", "packer.nvim")
    self.packer_compile_path = path.join_paths(self.config_dir, "plugin", "packer_compiled.lua")
    self.structlog_path = path.join_paths(self.cache_dir, "snvim.log")

    -- Make sure that nvim respects our runtime path configurations
    if os.getenv "SNVIM_RUNTIME_DIR" then
        vim.opt.rtp:remove(path.join_paths(vim.fn.stdpath "data", "site"))
        vim.opt.rtp:remove(path.join_paths(vim.fn.stdpath "data", "site", "after"))
        vim.opt.rtp:prepend(path.join_paths(self.runtime_dir, "site"))
        vim.opt.rtp:append(path.join_paths(self.runtime_dir, "site", "after"))
    end
    if os.getenv "SNVIM_CONFIG_DIR" then
        vim.opt.rtp:remove(vim.fn.stdpath "config")
        vim.opt.rtp:remove(path.join_paths(vim.fn.stdpath "config", "after"))
        vim.opt.rtp:prepend(self.config_dir)
        vim.opt.rtp:remove(path.join_paths(self.config_dir, "after"))
    end
    -- TODO: We need something like vim.opt.packpath = vim.opt.rtp
    vim.cmd [[let &packpath = &runtimepath]]

    return self
end


function M:start()
    ensure_version()

    -- Load plugins first
    local packer_tools = require "snvim.core.packer"
    -- Bootstrap packer if it's not already installed
    if not path.is_directory(self.packer_install_dir) then
        packer_tools.bootstrap_packer(self.packer_install_dir)
    end
    packer_tools.init()
    packer_tools.load_plugins(settings.get_settings("plugins"))

    require "snvim.core.options"
    require "snvim.core.autocommands"
    require "snvim.core.theme"

    -- TODO: Load Theme? (Could be part of above)

    -- TODO: Load LSP
end

-- This defines Snvim as a global, so after this is executed,
-- it will be accessible from everywhere.
Snvim = M:init()
Snvim:start()
