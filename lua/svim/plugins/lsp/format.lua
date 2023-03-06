local M = {}

M.autoformat = false

M.pattern = "*"
M.timeout = 1000

---filter passed to vim.lsp.buf.format
---always selects null-ls if it's available and caches the value per buffer
---@param client table client attached to a buffer
---@return boolean if client matches
function M.format_filter(client)
  local null_ls_ok, null_ls = pcall(require, "null-ls")
  local available_formatters = {}
  if null_ls_ok then
    local filetype = vim.bo.filetype
    local sources = require("null-ls.sources")
    local method = null_ls.methods.FORMATTING
    available_formatters = sources.get_available(filetype, method)
  end

  if #available_formatters > 0 then
    return client.name == "null-ls"
  elseif client.supports_method "textDocument/formatting" then
      return true
  else
    return false
  end
end

function M.enable_format_on_save()
  vim.api.nvim_create_augroup("lsp_format_on_save", {})
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = "lsp_format_on_save",
    pattern = M.format_opts.pattern,
    callback = function()
      M.format()
    end
  })
end

function M.disable_format_on_save()
  require("svim.utils.autocmds").clear_augroup("lsp_format_on_save")
end

function M.configure_format_on_save()
  if require("svim.vars").format_on_save then
    M.enable_format_on_save()
  else
    M.disable_format_on_save()
  end
end

function M.toggle()
  local exists, autocmds = pcall(vim.api.nvim_get_autocmds, {
    group = "lsp_format_on_save",
    event = "BufWritePre",
  })

  if not exists or #autocmds == 0 then
    M.enable_format_on_save()
    require("lazy.core.util").info("Enabled format on save", { title = "Format" })
  else
    M.diisable_format_on_save()
    require("lazy.core.util").info("Disabled format on save", { title = "Format" })
  end
end

---Simple wrapper for vim.lsp.buf.format() to provide defaults
---@param opts table|nil
function M.format(opts)
  opts = opts or {}
  opts.filter = opts.filter or M.format_filter
  opts.pattern = opts.pattern or M.pattern
  opts.timeout = opts.timeout or M.timeout

  return vim.lsp.buf.format(opts)
end

return M
