return {
  -- Bridge between mason package manager and lspconfig.
  -- This plugin is responsible for registering a setup hook with lspconfig that ensures:
  -- * That the servers installed with mason are set up with necessary configuration.
  -- * Translates between lspconfig server names and mason.nvim package names (e.g. lua_ls <-> lua-language-server)
  -- * Provides convenience APIs like :LspInstall
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" }, -- specified in core spec
    cmd = { "LspInstall", "LspUninstall" },
    version = false,
    lazy = true,
    opts = {
      ensure_installed = {
        -- "rust_analyzer",
        -- "pyright",
        -- "lua-language-server",
      },
      automatic_installation = {
        exclude = {},
      },
    },
  },

  -- Using LSP to inject diagnostics, code actions, do formatting, etc. via lua
  -- requested and setup from svim.plugins.lsp.setup
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "mason.nvim" }, -- specified in core spec
    lazy = true,
  },

  -- SImilar to mason-lspconfig, this plugin will configure null-ls to automatically
  -- pick up mason linters and formatters, and set up null-ls with them.
  -- requested and setup from svim.plugins.lsp.null-ls
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "mason.nvim", -- specified in core spec
      "null-ls.nvim", -- specified in lsp spec (above)
    },
    cmd = { "NullLsInstall", "NullLsUninstall", "NullLsLog", "NullLsInfo" },
    version = "*",
    lazy = false,
  },


  -- Configuring language servers using JSON files (both global, and local/project settings)
  { "folke/neoconf.nvim", cmd = "Neoconf", config = true, lazy = true },

  -- Changes the lua_ls config for the neovim config, runtime and plugin dirs,
  -- automatically making lua-language-server pick up vim functions, neovim apis, ...
  { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } }, lazy = true },

  -- Configurations for various language servers
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-lspconfig.nvim", -- specified in lsp spec (above)
      "mason-null-ls.nvim", -- specified in lsp spec (above)
      "null-ls.nvim", -- specified in lsp spec (above)
      "neoconf.nvim", -- specified in lsp spec (above)
      "neodev.nvim", -- specified in lsp spec (above)
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("svim.plugins.lsp.setup").init()
    end
  },
}
