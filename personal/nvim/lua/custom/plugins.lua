-- =============================================================================
-- lua/custom/plugins.lua — Personal plugin additions on top of NvChad
-- =============================================================================

local plugins = {

  -- -------------------------------------------------------------------------
  -- LSP / completion
  -- -------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("custom.configs.lspconfig")
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Python
        "pyright",
        "ruff-lsp",
        "mypy",
        -- Lua
        "lua-language-server",
        -- Shell
        "bash-language-server",
        "shellcheck",
        "shfmt",
        -- YAML / TOML
        "yaml-language-server",
        "taplo",
        -- Markdown
        "marksman",
        -- Fortran
        -- fortls: hover, go-to-definition, completion, symbols
        "fortls",
        -- fortitude: Rust-based Fortran linter; style + correctness rules
        -- aligned with the Fortran Best Practices guide.
        -- Mason package name is "fortitude-py" (PyPI distribution).
        "fortitude-py",
      },
    },
  },

  -- -------------------------------------------------------------------------
  -- nvim-lint + mason-nvim-lint
  --
  -- nvim-lint runs linters asynchronously outside the LSP protocol.  This
  -- suits tools like Fortitude that have no LSP wrapper, and mypy which
  -- benefits from not blocking the formatter on save.
  --
  -- mason-nvim-lint bridges Mason-managed binary paths into nvim-lint's
  -- linter registry automatically — no manual path configuration.
  --
  -- Coexists with none-ls: none-ls handles formatters and format-on-save;
  -- nvim-lint handles async linting.  No linter runs in both.
  -- -------------------------------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        fortran = { "fortitude" },
        -- mypy runs here rather than in none-ls so it doesn't block
        -- the ruff formatter on BufWritePre.
        python  = { "mypy" },
        sh      = { "shellcheck" },
        bash    = { "shellcheck" },
      }

      -- Fortitude ships a `fortitude check` subcommand.  Define a custom
      -- nvim-lint linter entry to invoke it and parse its output.
      lint.linters.fortitude = {
        name = "fortitude",
        cmd  = "fortitude",
        args = {
          "check",
          "--output-format=concise",  -- path:line:col: CODE message
          "--stdin-filename",
          function() return vim.api.nvim_buf_get_name(0) end,
        },
        stdin           = true,
        stream          = "stderr",
        ignore_exitcode = true,   -- non-zero just means violations found
        parser = require("lint.parser").from_pattern(
          -- concise format: /path/to/file.f90:10:4: T001 message text
          "([^:]+):(%d+):(%d+): (%u%-%d+) (.*)",
          { "file", "lnum", "col", "code", "message" },
          nil,
          { severity = vim.diagnostic.severity.WARN }
        ),
      }

      -- Trigger linting after write and on leaving insert mode, but only
      -- for filetypes that have a linter configured.
      vim.api.nvim_create_autocmd(
        { "BufWritePost", "InsertLeave", "BufReadPost" },
        {
          callback = function()
            local ft = vim.bo.filetype
            if lint.linters_by_ft[ft] then
              lint.try_lint()
            end
          end,
        }
      )
    end,
  },

  {
    "rshkarin/mason-nvim-lint",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-lint" },
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    opts = {
      -- Mason package names (not nvim-lint linter names).
      ensure_installed = {
        "fortitude-py",
        "mypy",
        "shellcheck",
      },
      automatic_installation = true,
    },
  },

  {
    "nvimtools/none-ls.nvim",
    -- fortran added: fprettify handles free-form Fortran formatting
    -- mypy removed from here — it now runs via nvim-lint asynchronously
    ft = { "python", "sh", "bash", "yaml", "markdown", "fortran" },
    opts = function()
      return require("custom.configs.null-ls")
    end,
  },

  -- -------------------------------------------------------------------------
  -- Treesitter — extra parsers
  -- -------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "python", "lua", "bash", "yaml", "toml", "json",
        "markdown", "markdown_inline", "vim", "vimdoc",
        "fortran",
      },
    },
  },

  -- -------------------------------------------------------------------------
  -- Git
  -- -------------------------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },
      current_line_blame = true,
      current_line_blame_opts = { delay = 500 },
    },
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- -------------------------------------------------------------------------
  -- Navigation / search
  -- -------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = { ".git/", "__pycache__/", ".venv/", "node_modules/" },
      },
    },
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  -- -------------------------------------------------------------------------
  -- Editing quality-of-life
  -- -------------------------------------------------------------------------
  { "tpope/vim-surround",   lazy = false },
  { "tpope/vim-repeat",     lazy = false },
  { "tpope/vim-unimpaired", lazy = false },

  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "BufReadPost",
    opts = {},
  },

  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    opts = {},
  },

  -- -------------------------------------------------------------------------
  -- Python-specific
  -- -------------------------------------------------------------------------
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    opts = {
      name = { ".venv", "venv", "env" },
      auto_refresh = true,
    },
  },

}

return plugins
