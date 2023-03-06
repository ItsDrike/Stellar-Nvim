local M = {}

local icons = require("svim.vars.icons").diagnostics

-- Use LSP's highlight capabilities if available for highlighting
M.document_highlight = true

-- options for vim.diagnostic.config
M.diagnostic_opts = {
  signs = {
    active = true,
    values = {
      { name = "DiagnosticSignError", text = icons.Error },
      { name = "DiagnosticSignWarn", text = icons.Warn },
      { name = "DiagnosticSignHint", text = icons.Hint },
      { name = "DiagnosticSignInfo", text = icons.Information },
    },
  },
  virtual_text = { spacing = 4, prefix = require("svim.vars.icons").ui.Circle },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    format = function(d)
      local code = d.code or (d.user_data and d.user_data.lsp.code)
      if code then
        return string.format("%s [%s]", d.message, code):gsub("1. ", "")
      end
      return d.message
    end,
  },
}

-- Options for floating window shown on hover or signature help
-- (will only be applied as a fallback, if noice isn't installed / is disabled for these)
M.float_opts = {
  focusable = true,
  style = "minimal",
  border = "rounded",
}

-- Options passed to mason-null-ls setup function
M.mason_null_ls_opts = {
  automatic_setup = true,
  ensure_installed = {
    -- "stylua",
    -- "jq",
    -- "flake8",
  }
}

M._common_capabilities = nil

---Get common capabilities shared for all language servers
---Cache the results if ran more than once
function M.get_common_capabilities()
  if not M._common_capabilities then
    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if status_ok then
      return cmp_nvim_lsp.default_capabilities()
    end

    M._common_capabilities = vim.lsp.protocol.make_client_capabilities()
    M._common_capabilities.textDocument.completion.completionItem.snippetSupport = true
    M._common_capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    }
  end

  return M._common_capabilities
end

function M.init()
  -- Use custom icons for diagnostic signs
  for name, icon in pairs(require("svim.vars.icons").diagnostics) do
    name = "DiagnosticSign" .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end

  -- Configure diagnostic options
  vim.diagnostic.config(M.diagnostic_opts)

  -- Configure handlers (hover, signature) float window style
  M.setup_handlers()

  -- Run M.on_attach and M.on_detach any time a language server is attached/detached to/from a buffer
  require("svim.utils.lsp").on_attach(M.on_attach)
  require("svim.utils.lsp").on_detach(M.on_detach)

  -- Setup the language servers installed by mason with our setup function
  local mason_ok, mason = pcall(require, "mason-lspconfig")
  if not mason_ok then
    vim.notify("Unable to setup mason language servers, mason-lspconfig plugin not available!", vim.log.levels.WARN)
  else
    mason.setup_handlers({ M.setup })
  end

  -- Setup null-ls for integrating external linters/formatters via LSP
  --require("svim.plugins.lsp.null-ls").setup(M.get_common_capabilities())
  M.setup_null_ls()

  -- Enable autoformatting (if svim.vars.init.autoformat)
  require("svim.plugins.lsp.format").configure_format_on_save()
end

---Configure style of floating windows for hover and signature help, unless they're already handled by noice
function M.setup_handlers()
  local noice_hover, noice_signature
  ---@cast noice_hover boolean
  ---@cast noice_signature boolean
  if require("svim.utils.plugins").has("noice.nvim") then
    local noice_ok, noice_config = pcall(require, "noice.config")
    if not noice_ok then
      vim.notify("Noice was marked installed, but required failed!", vim.log.levels.ERROR)
      noice_hover = false
      noice_signature = false
    else
      -- Any of the fields can be nil
      noice_hover = noice_config.options.lsp and noice_config.options.lsp.hover and noice_config.options.lsp.hover.enabled or false
      noice_signature = noice_config.options.lsp and noice_config.options.lsp.signature and noice_config.options.lsp.signature.enabled or false
      end
    end

  if not noice_hover then
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, M.float_opts)
  end
  if not noice_signature then
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, M.float_opts)
  end
end

---Function responsible for setting up given language server (with lspconfig)
---@param server string
function M.setup(server)
  local status_ok, lspconfig = pcall(require, "lspconfig")

  if not status_ok then
    vim.notify("Unable to setup " .. server .. " language server, lspconfig plugin not available!", vim.log.levels.ERROR)
    error("Exiting")
  end

  lspconfig[server].setup(M.get_common_capabilities())
end

---Function responsible for setting up given language server (with lspconfig)
function M.setup_null_ls()
  local null_ls_ok, null_ls = pcall(require, "null-ls")
  if not null_ls_ok then
    vim.notify("Unable to setup null ls servers, null-ls plugin not available!")
    return
  end

  local mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")
  if not mason_null_ls_ok then
    vim.notify("Unable to setup mason null ls servers, mason-null-ls plugin not available!", vim.log.levels.WARN)
    return
  end

  mason_null_ls.setup(M.mason_null_ls_opts)
  null_ls.setup({ sources = {} })  -- { sources = { ...} } can be passed, for extra non-mason null-ls sources

  if M.mason_null_ls_opts.automatic_setup then
    mason_null_ls.setup_handlers()
  end
end

---Function ran every time a language server is added (attached) to a buffer
function M.on_attach(client, bufnr)
  require("svim.plugins.lsp.keymaps").on_attach(client, bufnr)
  M.setup_codelens_refresh(client, bufnr)
  M.add_lsp_buffer_options(client, bufnr)
  M.add_document_symbols(client, bufnr)

  if M.document_highlight then
    M.setup_document_highlight(client, bufnr)
  end
end

---Function ran just before a language server is detached from a buffer
function M.on_detach(_, _)
  if M.document_highlight then
    pcall(function()
      vim.api.nvim_clear_autocmds({ group = "lsp_document_highlight" })
    end)
  end
end

function M.add_lsp_buffer_options(_, bufnr)
  -- enable completion triggered by <C-x><C-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  -- use gq for formatting
  vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr(#{timeout_ms:500})")
end

function M.setup_document_highlight(client, bufnr)
  -- Skip document highlighting if illuminate is already active
  if require("svim.utils.plugins").has("vim-illuminate") then
    return
  end

  local status_ok, highlight_supported = pcall(function()
    return client.supports_method "textDocument/documentHighlight"
  end)
  if not status_ok or not highlight_supported then
    return
  end
  local group = "lsp_document_highlight"
  local hl_events = { "CursorHold", "CursorHoldI" }

  local ok, hl_autocmds = pcall(vim.api.nvim_get_autocmds, {
    group = group,
    buffer = bufnr,
    event = hl_events,
  })

  if ok and #hl_autocmds > 0 then
    return
  end

  vim.api.nvim_create_augroup(group, { clear = false })
  vim.api.nvim_create_autocmd(hl_events, {
    group = group,
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })
end

function M.add_document_symbols(client, bufnr)
  vim.g.navic_silence = false -- can be set to true to suppress error

  local symbols_supported = client.supports_method "textDocument/documentSymbol"
  if not symbols_supported then
    return
  end

  local status_ok, navic = pcall(require, "nvim-navic")
  if status_ok then
    navic.attach(client, bufnr)
  end
end

function M.setup_codelens_refresh(client, bufnr)
  local status_ok, codelens_supported = pcall(function()
    return client.supports_method "textDocument/codeLens"
  end)
  if not status_ok or not codelens_supported then
    return
  end
  local group = "lsp_code_lens_refresh"
  local cl_events = { "BufEnter", "InsertLeave" }
  local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
    group = group,
    buffer = bufnr,
    event = cl_events,
  })

  if ok and #cl_autocmds > 0 then
    return
  end
  vim.api.nvim_create_augroup(group, { clear = false })
  vim.api.nvim_create_autocmd(cl_events, {
    group = group,
    buffer = bufnr,
    callback = vim.lsp.codelens.refresh,
  })
end

return M
