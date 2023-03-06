-- This file contains configuration for individual cmp sources

local M = {}

function M.get()
  -- Define this here, since it's expensive to call this over and over in checks later
  local has_treesitter = require("svim.utils.plugins").has("nvim-treesitter")

  return {
    { name = "nvim_lsp_signature_help" },
    {
      name = "nvim_lsp",
      -- Reduce noise from LSP for Text completions
      -- we have buffer source for this
      entry_filter = function(entry, _)
        local kind = require("cmp.types").lsp.CompletionItemKind[entry:get_kind()]
        if kind == "Text" then
          return false
        end
        return true
      end,
    },
    { name = "path" },
    { name = "luasnip" },
    { name = "nvim_lua" },
    {
      name = "copilot",
      -- keyword_length = 0
      max_item_count = 3,
      trigger_characters = {
        {
          ".",
          ":",
          "(",
          "'",
          '"',
          "[",
          ",",
          "#",
          "*",
          "@",
          "|",
          "=",
          "-",
          "/",
          "\\",
          "+",
          "?",
          " ",
          -- "\t",
          -- "\n",
        },
      },
    },
    { name = "cmp_tabnine" },
    { name = "buffer" },
    { name = "calc" },
    { name = "emoji" },
    { name = "treesitter" },
    { name = "crates" },
    { name = "tmux" },
  }
end

return M
