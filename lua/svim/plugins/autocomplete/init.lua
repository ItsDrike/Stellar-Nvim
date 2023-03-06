return {
  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = { "friendly-snippets" },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    config = function()
      local Path = require("svim.utils.path")
      local paths = {}
      if require("svim.utils.plugins").has("friendly-snippets") then
        paths[#paths + 1] = Path.join_paths(Path.plugins_dir, "friendly-snippets")
      end
      local user_snippets = Path.join_paths(Path.config_dir, "snippets")
      if Path.is_directory(user_snippets) then
        paths[#paths + 1] = user_snippets
      end

      require("luasnip.loaders.from_lua").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = paths })
      require("luasnip.loaders.from_snipmate").lazy_load()
    end
  },

  -- Collection of snippets for various programming langs in a single repo
  -- works with vim-vsnip, luasnip and coc-snippets
  { "rafamadriz/friendly-snippets", lazy = true },

  -- Code completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- nvim-cmp only did one release, which is way too old
    event = "InsertEnter",
    dependencies = {
      "cmp-nvim-lsp",
      "cmp-buffer",
      "cmp-path",
      "cmp-spell",
      "cmp_luasnip",
      "cmp-calc",
      "cmp-emoji",
      "nvim-cmp-buffer-lines",
      "cmp-nvim-lsp-signature-help",
    },
    opts = function()
      local cmp = require("cmp")
      local cmp_window = require("cmp.config.window")

      return {
        enabled = function()
          local buftype = vim.api.nvim_buf_get_option(0, "buftype")
          if buftype == "prompt" then
            return false
          end
          return true
        end,
        completion = {
          ---@usage The minimum length of a word to complete on
          keyword_length = 1,
        },
        experimental = {
          ghost_text = false,
          native_menu = false,
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp_window.bordered(),
          documentation = cmp_window.bordered(),
        },
        formatting = require("svim.plugins.autocomplete.formatting").get(),
        sources = require("svim.plugins.autocomplete.sources").get(),
        mapping = cmp.mapping.preset.insert(require("svim.plugins.autocomplete.keymaps").get()),
      }
    end
  },

  -- Completion source for language server completions
  { "hrsh7th/cmp-nvim-lsp", lazy = true },

  -- Completion source for words from (already in) current buffer
  { "hrsh7th/cmp-buffer", lazy = true },

  -- Completion source for entire lines from current bufferr
  { "amarakon/nvim-cmp-buffer-lines", lazy = true, enabled = false },

  -- Completion source for file paths existing on the system
  { "hrsh7th/cmp-path", lazy = true },

  -- Completion source for resolving quick simple math prompts
  { "hrsh7th/cmp-calc", lazy = true },

  -- Completion source for getting emojis from terms like :star:
  { "hrsh7th/cmp-emoji", lazzy = true },

  -- Completion source for Luasnip snippets
  {
    "saadparwaiz1/cmp_luasnip",
    lazy = true,
    dependencies = { "LuaSnip" }, -- specified in the autocomplete spec (above)
  },

  -- Completion source for nvim commandline
  {
    "hrsh7th/cmp-cmdline",
    event = { "CmdLineEnter" },
    dependencies = {
       -- specified in autocomplete spec (above)
      "nvim-cmp",
      "cmp-buffer",
      "cmp-path",
      "cmp-nvim-lsp-document-symbol",
    },
    opts = {
      options = {
        {
          type = ":",
          sources = { { name = "path" } },
        },
        {
          type = { "/", "?" },
          sources = { { name = "nvim_lsp_document_symbol" }, { name = "buffer" } },
        },
      },
    },
    config = function(_, opts)
      local cmp = require("cmp")
      for _, option in ipairs(opts.options) do
        cmp.setup.cmdline(option.type, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = option.sources,
        })
      end
    end,
  },

  -- Completion source for LSP symbols completion in commandline / search
  { "hrsh7th/cmp-nvim-lsp-document-symbol", lazy = true },
}
