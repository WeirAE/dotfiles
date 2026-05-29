-- =============================================================================
-- lua/custom/configs/lspconfig.lua — LSP server setup
-- =============================================================================

local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

-- ---------------------------------------------------------------------------
-- Servers with default settings
-- ---------------------------------------------------------------------------
local default_servers = {
  "bashls",     -- bash-language-server
  "marksman",   -- markdown
  "taplo",      -- TOML
  "yamlls",     -- YAML
}

for _, server in ipairs(default_servers) do
  lspconfig[server].setup({
    on_attach    = on_attach,
    capabilities = capabilities,
  })
end

-- ---------------------------------------------------------------------------
-- Pyright — Python type checking
-- ---------------------------------------------------------------------------
lspconfig.pyright.setup({
  on_attach    = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode      = "standard",
        autoSearchPaths       = true,
        useLibraryCodeForTypes = true,
        -- Let mypy handle full strict checking
        diagnosticMode        = "workspace",
      },
    },
  },
})

-- ---------------------------------------------------------------------------
-- ruff-lsp — linting / formatting (replaces flake8 + isort)
-- ---------------------------------------------------------------------------
lspconfig.ruff_lsp.setup({
  on_attach = function(client, bufnr)
    -- Disable hover in favour of pyright
    client.server_capabilities.hoverProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  init_options = {
    settings = {
      args = {},
    },
  },
})

-- ---------------------------------------------------------------------------
-- Lua — nvim config editing
-- ---------------------------------------------------------------------------
lspconfig.lua_ls.setup({
  on_attach    = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace   = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry   = { enable = false },
    },
  },
})

-- ---------------------------------------------------------------------------
-- fortls — Fortran language server
-- Provides: hover docs, go-to-definition, find references, symbols,
-- completion.  Fortitude (via nvim-lint) handles linting separately.
--
-- fortls reads a .fortls config file in the project root if present.
-- Minimal defaults are set here; per-project overrides go in .fortls.
-- ---------------------------------------------------------------------------
lspconfig.fortls.setup({
  on_attach    = on_attach,
  capabilities = capabilities,
  cmd = {
    "fortls",
    "--notify_init",
    "--hover_signature",
    "--hover_language=fortran",   -- syntax-highlight hover blocks as Fortran
    "--use_signature_help",
  },
  filetypes = { "fortran" },
  root_dir = lspconfig.util.root_pattern(
    ".fortls",     -- explicit project config (preferred)
    ".git",        -- git root fallback
    "CMakeLists.txt",
    "Makefile"
  ),
})
