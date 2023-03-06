local M = {}

local Icons = require("svim.vars.icons")

M.opts = {
  ---@usage Will cut off any suggestions longer than this width, set to 0 to disable
  max_width = 0,

  ---@usage Neby text shown for given source name
  source_names = {
    nvim_lsp = "[LSP]",
    emoji = "[Emoji]",
    path = "[Path]",
    calc = "[Calc]",
    cmp_tabnine = "[Tabnine]",
    vsnip = "[Snippet]",
    luasnip = "[Snippet]",
    buffer = "[Buffer]",
    tmux = "[TMUX]",
    copilot = "[Copilot]",
    treesitter = "[TreeSitter]",
  },

  ---@usage Fallback function used if source nane didn't match any of the source_names
  ---@param name string
  unknown_source_name_formatter = function(name)
    return "[" .. name .. "?]"
  end,

  ---@usage Specifies maximum amount of entries for a specific single source, 0 means no limit
  duplicates = {
    buffer = 1,
    path = 1,
    nvim_lsp = 0,
    luasnip = 1,
  },

  ---@usage Default amount of allowed duplicates for sources without explicit setting in duplicates, 0 means no limit
  duplicates_default = 0
}

function M.format(entry, vim_item)
  -- Limit suggestions up to max_width
  if M.opts.max_width ~= 0 and #vim_item.abbr > M.opts.max_width then
    vim_item.abbr = string.sub(vim_item.abbr, 1, M.opts.max_width - 1 .. Icons.ui.Ellipsis)
  end

  -- Set kind icon for items (also sets highlight group for sources without a default one)
  M.set_kind(entry, vim_item)

  -- Formatted source name
  vim_item.menu = M.opts.source_names[entry.source.name] or M.opts.unknown_source_name_formatter(entry.source.name)

  -- Limit duplicates
  vim_item.dup = M.opts.duplicates[entry.source.name] or M.opts.duplicates_default

  return vim_item
end

---Set kind icon and highlight group for suggestion item
function M.set_kind(entry, vim_item)
  if entry.source.name == "copilot" then
    vim_item.kind = Icons.git.Octoface
    vim_item.kind.hl_group = "CmpItemKindCopilot"
  elseif entry.source.name == "cmp_tabnine" then
    vim_item.kind = Icons.misc.Robot
    vim_item.kind.hl_group = "CmpItemKindTabnine"
  elseif entry.source_name == "crates" then
    vim_item.kind = Icons.misc.Package
    vim_item.kind.hl_group = "CmpItemKindCrate"
  elseif entry.source_name == "lab.quick_data" then
    vim_item.kind = Icons.misc.CircuitBoard
    vim_item.kind.hl_group = "CmpItemKindConstant"
  elseif entry.source.name == "emoji" then
    vim_item.kind = Icons.misc.Smiley
    vim_item.kind.hl_group = "CmpItemKindEmoji"
  else
    vim_item.kind = Icons.kind[vim_item.kind]
  end
end

function M.get()
  return {
    fields = { "kind", "abbr", "menu" },
    format = M.format,
  }
end

return M
