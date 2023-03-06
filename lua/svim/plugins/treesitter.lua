return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    keys = {
      { "<C-Space>", desc = "Increment selection" },
      { "<BS>", desc = "Schrink selection", mode = "x" },
    },
    cmd = {
      "TSInstall",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
      "TSInstallInfo",
      "TSInstallSync",
      "TSInstallFromGrammar",
    },
    ---@type TSConfig
    opts = {
      highlight = {
        enable = true,  -- false will disable the whole extension
        additional_vim_regex_highlighting = false,
        disable = function(lang, buf)
          if vim.tbl_contains({ "latex" }, lang) then
            return true
          end

          local status_ok, big_file_detected = pcall(vim.api.nvim_buf_get_var, buf, "bigfile_disable_treesitter")
          return status_ok and big_file_detected
        end,
      },
      indent = { enable = true, disable = { "python", "yaml" } },
      context_commentstring = { enable = true, enable_autocmd = false },
      ensure_installed = {
        "bash",
        "c",
        "help",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-Space>",
          node_incremental = "<C-Space>",
          scope_incremental = "<nop>",
          node_decremental = "<BS>",
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      local Path = require("svim.utils.path")
      local path = Path.join_paths(Path.plugins_dir, "nvim-treesitter")
      vim.opt.runtimepath:prepend(path) -- treesitter needs to be before nvim's runtime in rtp
      require("nvim-treesitter.configs").setup(opts)
    end
  },

  -- Lazy loaded by mini.comment
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    version = false, -- this plugin doesn't have any releasees
    lazy = true
  },

  -- Lay loaded by mini.ai
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    version = false, -- this plugin doesn't have any releases
    lazy = true
  },
}

