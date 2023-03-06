local Path = require("svim.utils.path")
local colorscheme = require("svim.vars").colorscheme

local M = {}

---@class LazyConf
M.lazy_opts = {
  checker = { enabled = true }, -- automatically check for plugin updates
  install = {
    missing = true,
    colorscheme = { colorscheme, "habamax" },
  },
  defaults = {
    -- Only load plugins when they're needed
    -- (when they're lua requested, or when one of the lazy-loading handlers triggers)
    lazy = true,
    -- It's recommended to leave version=false for now, since not a lot of the plugins
    -- support versioning or have outdated releases, which may break your Neovim install.
    version = false, -- always install latest git commit
    --version = "*", -- try installing the latest stable version for plugins that support semver
  },
  ui = { border = "rounded" },
  lockfile = Path.join_paths(Path.config_dir, "lazy-lock.json"),
}

---Initialize the plugin manager (folke/lazy.nvim), bootstrap if needed
function M.init()
  local install_dir = Path.join_paths(Path.runtime_dir, "lazy", "lazy.nvim")

  if not Path.is_directory(install_dir) then
    print("Initializing first time setup")
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--branch=stable",
      "https://github.com/folke/lazy.nvim.git",
      install_dir,
    })
  end

  vim.opt.runtimepath:prepend(install_dir)
end

---Setup lazy (standalone, without installing plugins yet)
---@param spec table[]
function M.setup(spec)
  local lazy_available, Lazy = pcall(require, "lazy")
  if not lazy_available then
    vim.notify("Unable to run load plugins, lazy.nvim is not installed!", vim.log.levels.ERROR)
    error("Exiting")
  end

  local status_ok = xpcall(function()
    Lazy.setup(vim.tbl_deep_extend("force", M.lazy_opts, { spec = spec }))
  end, debug.traceback)

  if not status_ok then
    vim.notify("Problems detected while loading plugin manager", vim.log.levels.ERROR)
    vim.notify(debug.traceback(), vim.log.levels.WARN)
    error("Exiting")
  end
end


---Install all plugins
function M.ensure_plugins()
  local status_ok, lazy = pcall(require, "lazy")
  if not status_ok then
    vim.notify("Unable to load plugins, lazy.nvim is not installed!")
    error("Exiting")
  end

  local Config = require("lazy.core.config")
  require("lazy.core.plugin").load(true)
  require("lazy.core.plugin").update_state()

  local not_installed_plugins = vim.tbl_filter(function(plugin)
    return not plugin._.installed
  end, Config.plugins)

  require("lazy.manage").clear()

  if #not_installed_plugins > 0 then
    lazy.install({ wait = true, show = true })
  end

  if #Config.to_clean > 0 then
    lazy.clean({ wait = true, show = true })
  end
end

return M
