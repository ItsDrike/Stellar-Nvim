return {
  -- Plugin manager
  { "folke/lazy.nvim", tag = "stable" },

  -- Package manager for neovim that can install and manage LSP servers, DAP servers, linters, and formatters.
  -- Note that mason alone won't configure the LSP servers, or any other tools, it is purely a cross-platform
  -- package manager, that installs selected utilities and adds them into a single bin/ directory, which it
  -- then prepends them into nvim's runtimepath, making these tools take precedence over locally installed ones.
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    keys = { { "<leader>cm", "<cmd>Mason<CR>", desc = "Mason" } },
    lazy = true,
    opts = {
      ensure_installed = {
        -- "stylua",
        -- "shellcheck",
        -- "shfmt",
        -- "flake8",
        -- "black",
        -- "codespell",
        -- "lua-language-server",
        -- "pyright",
        -- "json-lsp",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(plugin, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },
}
