local M = {}

---sets the current buffer's luasnip to one nearest the cursor
---@return boolean true if a node is found, false otherwise
local function _seek_luasnip_cursor_node()
  local luasnip = require("luasnip")

  -- for outdated versions of luasnip
  if not luasnip.session.current_nodes then
    return false
  end

  local buf = vim.api.nvim_get_current_buf()

  local node = luasnip.session.current_nodes[buf]
  if not node then
    return false
  end

  local snippet = node.parent.snippet
  local exit_node = snippet.insert_nodes[0]

  local pos = vim.api.nvim_win_get_cursor()
  pos[1] = pos[1] - 1

  -- Exit early if we're past the exit node
  if exit_node then
    local exit_pos_end = exit_node.mark:pos_end()
    if (pos[1] > exit_pos_end[1]) or (pos[1] == exit_pos_end[1] and pos[2] > exit_pos_end[2]) then
      snippet:remove_from_jumplist()
      luasnip.session.current_nodes[buf] = nil
      return false
    end
  end

  node = snippet.inner_first:jump_into(1, true)
  while node ~= nil and node.next ~= nil and node ~= snippet do
    local n_next = node.next
    local next_pos = n_next and n_next.mark:pos_begin()
    local candidate = n_next ~= snippet and next_pos and (pos[1] < next_pos[1])
      or (pos[1] == next_pos[1] and pos[2] < next_pos[2])

    -- Past unmarked exit node, exit early
    if n_next == nil or n_next == snippet.next then
      snippet:remove_from_jumplist()
      luasnip.session.current_nodes[buf] = nil
      return false
    end

    if candidate then
      luasnip.session.current_nodes[buf] = node
      return true
    end

    local ok
    ok, node = pcall(node.jump_from, node, 1, true)
    if not ok then
      snippet:remove_from_jumplist()
      luasnip.session.current_nodes[buf] = nil
      return false
    end
  end

  -- No candidate, but have an exit node
  if exit_node then
    -- to jump to the exit node, seek to snippet
    luasnip.session.current_nodes[buf] = snippet
    return true
  end

  -- No exit node, exit from snippet
  snippet:remove_from_jumplist()
  luasnip.session.current_nodes[buf] = nil
  return false
end

---When inside a snippet, seeks to nearest luasnip field if possible, and checks if it's jumpable
---@param dir number 1 for forward, -1 for backward
---@return boolean true if a jumpable luasnip field is found while inside a snippet
local function jumpable(dir)
  local luasnip = require("luasnip")
  if dir == -1 then
    return luasnip.in_snippet() and luasnip.jumpable(-1)
  else
    return luasnip.in_snippet() and _seek_luasnip_cursor_node() and luasnip.jumpable(-1)
  end
end

function M.get()
  local cmp = require("cmp")

  return {
    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }, { "i", "c" }),
    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }, { "i", "c" }),
    ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }, { "i" }),
    ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }, { "i" }),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-y>"] = cmp.mapping({
      i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
      c = function(fallback)
        if cmp.visible() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        else
          fallback()
        end
      end,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        local luasnip = require("luasnip")
        if luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        local luasnip = require("luasnip")
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end
    end, { "i", "s" }),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        local confirm_opts = { behavior = cmp.ConfirmBehavior.Replace, select = false }

        -- If in insert mode
        if vim.api.nvim_get_mode().mode:sub(1, 1) == "i" then
          confirm_opts.behavior = cmp.ConfirmBehavior.Insert
        end

        -- confirm the suggestion, exit early on success
        if cmp.confirm(confirm_opts) then
          return
        end
      end

      -- try luasnip jump instead, exiit early on success
      if jumpable(1) and require("luasnip").jump(1) then
        return
      end

      fallback()
    end),
  }
end

return M
