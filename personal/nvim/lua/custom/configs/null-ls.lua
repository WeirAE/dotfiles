-- =============================================================================
-- lua/custom/configs/null-ls.lua — Formatters via none-ls
--
-- Responsibilities after the nvim-lint split:
--   none-ls  →  formatters only (runs synchronously on BufWritePre)
--   nvim-lint →  async linters: fortitude, mypy, shellcheck
--
-- mypy is intentionally absent here; it moved to nvim-lint so it does not
-- block the ruff formatter on save.
-- =============================================================================

local null_ls = require("null-ls")
local fmt = null_ls.builtins.formatting

-- ---------------------------------------------------------------------------
-- fprettify — Fortran auto-formatter (free-form; Fortran 90+)
-- Not in Mason; installed separately:  pip install fprettify
-- or loaded via an environment module on HPC.
-- ---------------------------------------------------------------------------
local fprettify = {
  method  = null_ls.methods.FORMATTING,
  filetypes = { "fortran" },
  generator = null_ls.formatter({
    command = "fprettify",
    args = {
      "--indent", "2",          -- 2-space indent (matches .vimrc HPC convention)
      "--whitespace-comma", "1",
      "--whitespace-assignment", "1",
      "--whitespace-decl", "1",
      "--whitespace-relational", "1",
      "--whitespace-logical", "1",
      "--whitespace-plusminus", "1",
      "--whitespace-multdiv", "1",
      "--whitespace-print", "1",
      "--case", "1", "1", "1", "1",  -- keywords, types, constructs, modules → lowercase
      "-",                           -- read from stdin
    },
    to_stdin = true,
  }),
}

return {
  sources = {
    -- Python — ruff covers both formatting (Black-compatible) and import sorting.
    -- No Black entry: none-ls dropped the Black source; ruff format is the
    -- supported path.  For projects that require Black specifically, invoke it
    -- via a pre-commit hook or project-local tooling outside nvim.
    fmt.ruff,

    -- Shell
    fmt.shfmt.with({
      extra_args = { "-i", "4", "-ci", "-bn" },
    }),

    -- Lua
    fmt.stylua,

    -- YAML / Markdown
    fmt.prettier.with({
      filetypes = { "yaml", "markdown" },
    }),

    -- Fortran
    fprettify,
  },

  -- Format synchronously on save (BufWritePre) so the file on disk always
  -- reflects the formatted state.  Filtered to none-ls only so LSP servers
  -- that also offer formatting don't race.
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer   = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr  = bufnr,
            filter = function(c) return c.name == "null-ls" end,
          })
        end,
      })
    end
  end,
}
