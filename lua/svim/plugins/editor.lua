return {
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = {
      "nui.nvim", "nvim-web-devicons", "plenary.nvim", -- specified in utils spec
      {
        "s1n7ax/nvim-window-picker", -- specified here
        version = "^1",
        opts = {
          autoselect_one = true,
          include_current = false,
          filter_rules = {
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = {
                  "neo-tree",
                  "neo-tree-popup",
                  "notify",
                },

                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal", "quickfix" },
              },
            },
            other_win_hl_color = '#e35e4f',
        },
      },
    },
    version = "^2",
    -- Automatically open NeoTree if nvim was opened on a directory
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    opts = {
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = true,
      },
      window = {
        mappings = {
          ["<space>"] = "none",
        },
      },
    },
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = require("svim.utils.lsp").get_root() })
        end,
        desc = "Explorer NeoTree (root dir)"
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)"
      },
      { "<C-n>", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
      { "<C-S-n>", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    },
  },

  -- Highlight references of token under cursor
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- providers: provider used to get references in the buffer, ordered by priority
      providers = {
          'lsp',
          'treesitter',
          'regex',
      },
      delay = 200
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      -- Set the keybinds after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          vim.keymap.set("n", "]]", function()
            require("illuminate")["goto_next_reference"](false)
          end, { desc = "Next Reference", buffer = buffer })
          vim.keymap.set("n", "[[", function()
            require("illuminate")["goto_prev_reference"](false)
          end, { desc =  "Prev Reference", buffer = buffer })
        end,
      })
    end,
    keys = {
      { "]]", function() require("illuminate")["goto_next_reference"](false) end, desc = "Next Reference" },
      { "[[", function() require("illuminate")["goto_prev_reference"](false) end, desc = "Prev Reference" },
    },
  },

  -- Remove buffers, preserving window layouts
  {
    "echasnovski/mini.bufremove",
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },

  -- Search/Replace in multiple files
  {
    "windwp/nvim-spectre",
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            vim.cmd.cprev()
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            vim.cmd.cnext()
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  -- Highlight todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<CR>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<CR>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<CR>", desc = "Todo" },
    },
  },

  -- Simple git integration for staging/resetting hunks, showing diffs, blames, and seeing line status
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local icons = require("svim.vars.icons")

      return {
        signs = {
          add = { text = icons.ui.BoldLineLeft },
          change = { text = icons.ui.BoldLineLeft },
          delete = { text = icons.ui.Triangle },
          topdelete = { text = icons.ui.Triangle },
          changedelete = { text = icons.ui.BoldLineLeft },
        },
      }
    end,
    keys = {
        { "]h", function() require("gitsigns").next_hunk() end, desc = "Next Git Hunk" },
        { "[h", function() require("gitsigns").prev_hunk() end, desc = "Prev Git Hunk" },
        { "<leader>ghs", function() require("gitsigns").stage_hunk() end, desc = "Stage Hunk", mode = { "n", "v" } },
        { "<leader>ghr", function() require("gitsigns").reset_hunk() end, desc = "Reset Hunk", mode = { "n", "v" } },
        { "<leader>ghS", function() require("gitsigns").stage_buffer() end, desc = "Stage Buffer" },
        { "<leader>ghu", function() require("gitsigns").undo_stage_hunk() end, desc = "Undo Stage Hunk" },
        { "<leader>ghR", function() require("gitsigns").reset_buffer() end, desc = "Reset Buffer" },
        { "<leader>ghp", function() require("gitsigns").preview_hunk() end, desc = "Preview Hunk" },
        { "<leader>ghb", function() require("gitsigns").blame_line() end, desc = "Blame Line"},
        { "<leader>ghB", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame Line (full)" },
        { "<leader>ghd", function() require("gitsigns").diffthis() end, desc = "Diff This" },
        { "<leader>ghD", function() require("gitsigns").diffthis("~") end, "Diff This ~" },
        { "ih", function() require("gitsigns").select_hunk() end, desc = "GitSigns Select Hunk", mode = { "o", "x" } },
    },
  },

  -- Show defined keybinds
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    cmd = "WhichKey",
    opts = {
      plugins = { spelling = true },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      local keymaps = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gz"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks "},
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      }
      if require("svim.utils.plugins").has("noice.nvim") then
        keymaps["<leader>un"] = { name = "+noice" }
      end
      wk.register(keymaps)
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope only did one release, so use HEAD for now
    keys = {
      { "<leader>/", require("svim.utils.telescope").telescope("live_grep"), desc = "Find in Files (Grep)" },
      { "<leader>:", "<cmd>Telescope command_history<CR>", desc = "Command History" },

      -- buffers
      { "<leader>b,", "<cmd>Telescope buffers show_all_buffers=true<CR>", desc = "Switch Buffer" },
      { "<leader>,", "<leader>b,", desc = "Switch Buffer", remap = true },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },

      -- find
      { "<leader>ff", require("svim.utils.telescope").telescope("files"), desc = "Find Files (root dir)" },
      { "<leader><space>", "<leader>ff", desc = "Find Files (root dir)", remap = true },
      { "<leader>fF", require("svim.utils.telescope").telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent" },

      -- git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },

      -- search
      { "<leader>sa", "<cmd>Telescope autocommands<CR>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<CR>", desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<CR>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      { "<leader>sg", require("svim.utils.telescope").telescope("live_grep"), desc = "Grep (root dir)" },
      { "<leader>sG", require("svim.utils.telescope").telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
      { "<leader>sh", "<cmd>Telescope help_tags<CR>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<CR>", desc = "Search Highlight Groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<CR>", desc = "Key Maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<CR>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<CR>", desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<CR>", desc = "Options" },
      { "<leader>sR", "<cmd>Telescope resume<CR>", desc = "Resume" },
      { "<leader>sw", require("svim.utils.telescope").telescope("grep_string"), desc = "Word (root dir)" },
      { "<leader>sW", require("svim.utils.telescope").telescope("grep_string", { cwd = false }), desc = "Word (cwd)" },
      { "<leader>uC", require("svim.utils.telescope").telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
      {
        "<leader>ss",
        require("svim.utils.telescope").telescope("lsp_document_symbols", {
          symbols = {
            "Class",
            "Function",
            "Method",
            "Constructor",
            "Interface",
            "Module",
            "Struct",
            "Trait",
            "Field",
            "Property",
          },
        }),
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        require("svim.utils.telescope").telescope("lsp_workspace_symbols", {
          symbols = {
            "Class",
            "Function",
            "Method",
            "Constructor",
            "Interface",
            "Module",
            "Struct",
            "Trait",
            "Field",
            "Property",
          },
        }),
        desc = "Goto Symbol (Workspace)",
      },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        mappings = {
          i = {
            ["<c-t>"] = function(...)
              return require("trouble.providers.telescope").open_with_trouble(...)
            end,
            ["<a-t>"] = function(...)
              return require("trouble.providers.telescope").open_selected_with_trouble(...)
            end,
            ["<a-i>"] = function()
              require("svim.utils.telescope").telescope("find_files", { no_ignore = true })()
            end,
            ["<a-h>"] = function()
              require("svim.utils.telescope").telescope("find_files", { hidden = true })()
            end,
            ["<C-Down>"] = function(...)
              return require("telescope.actions").cycle_history_next(...)
            end,
            ["<C-Up>"] = function(...)
              return require("telescope.actions").cycle_history_prev(...)
            end,
            ["<C-f>"] = function(...)
              return require("telescope.actions").preview_scrolling_down(...)
            end,
            ["<C-b>"] = function(...)
              return require("telescope.actions").preview_scrolling_up(...)
            end,
          },
          n = {
            ["q"] = function(...)
              return require("telescope.actions").close(...)
            end,
          },
        },
      },
    },
  },

}
