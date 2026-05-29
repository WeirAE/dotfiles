-- =============================================================================
-- lua/custom/mappings.lua — Personal keybindings
-- NvChad mapping spec: { mode, lhs, rhs, opts }
-- =============================================================================

---@type MappingsTable
local M = {}

M.general = {
  n = {
    -- Save / quit shortcuts
    ["<leader>w"] = { "<cmd>w<CR>",  "Save file" },
    ["<leader>q"] = { "<cmd>q<CR>",  "Quit" },
    ["<leader>Q"] = { "<cmd>qa!<CR>", "Quit all (no save)" },

    -- Navigate splits with Alt+hjkl
    ["<A-h>"] = { "<C-w>h", "Window left" },
    ["<A-j>"] = { "<C-w>j", "Window down" },
    ["<A-k>"] = { "<C-w>k", "Window up" },
    ["<A-l>"] = { "<C-w>l", "Window right" },

    -- Resize splits
    ["<C-Up>"]    = { "<cmd>resize -2<CR>",          "Resize up" },
    ["<C-Down>"]  = { "<cmd>resize +2<CR>",          "Resize down" },
    ["<C-Left>"]  = { "<cmd>vertical resize -2<CR>", "Resize left" },
    ["<C-Right>"] = { "<cmd>vertical resize +2<CR>", "Resize right" },

    -- Buffer navigation
    ["<Tab>"]   = { "<cmd>bnext<CR>",     "Next buffer" },
    ["<S-Tab>"] = { "<cmd>bprevious<CR>", "Previous buffer" },

    -- Clear search highlight
    ["<Esc>"] = { "<cmd>noh<CR>", "Clear highlights" },

    -- Telescope
    ["<leader>ff"] = { "<cmd>Telescope find_files<CR>",              "Find files" },
    ["<leader>fg"] = { "<cmd>Telescope live_grep<CR>",               "Live grep" },
    ["<leader>fb"] = { "<cmd>Telescope buffers<CR>",                 "Buffers" },
    ["<leader>fh"] = { "<cmd>Telescope help_tags<CR>",               "Help tags" },
    ["<leader>fr"] = { "<cmd>Telescope oldfiles<CR>",                "Recent files" },
    ["<leader>fd"] = { "<cmd>Telescope diagnostics<CR>",             "Diagnostics" },
    ["<leader>fs"] = { "<cmd>Telescope lsp_document_symbols<CR>",    "Doc symbols" },

    -- Git (lazygit)
    ["<leader>gg"] = { "<cmd>LazyGit<CR>", "LazyGit" },

    -- Trouble diagnostics
    ["<leader>xx"] = { "<cmd>TroubleToggle<CR>",                    "Toggle trouble" },
    ["<leader>xw"] = { "<cmd>TroubleToggle workspace_diagnostics<CR>", "Workspace diag" },
    ["<leader>xd"] = { "<cmd>TroubleToggle document_diagnostics<CR>",  "Document diag" },

    -- Python venv
    ["<leader>pv"] = { "<cmd>VenvSelect<CR>", "Select venv" },
  },

  v = {
    -- Stay in indent mode
    ["<"] = { "<gv", "Indent left" },
    [">"] = { ">gv", "Indent right" },
    -- Move selected block up/down
    ["J"] = { ":m '>+1<CR>gv=gv", "Move block down" },
    ["K"] = { ":m '<-2<CR>gv=gv", "Move block up" },
  },
}

M.lspconfig = {
  n = {
    ["gd"]         = { vim.lsp.buf.definition,      "Go to definition" },
    ["gD"]         = { vim.lsp.buf.declaration,     "Go to declaration" },
    ["gr"]         = { vim.lsp.buf.references,      "References" },
    ["gi"]         = { vim.lsp.buf.implementation,  "Implementation" },
    ["K"]          = { vim.lsp.buf.hover,           "Hover docs" },
    ["<leader>ca"] = { vim.lsp.buf.code_action,     "Code action" },
    ["<leader>rn"] = { vim.lsp.buf.rename,          "Rename symbol" },
    ["<leader>lf"] = { function() vim.lsp.buf.format({ async = true }) end, "Format" },
    ["[d"]         = { vim.diagnostic.goto_prev,    "Prev diagnostic" },
    ["]d"]         = { vim.diagnostic.goto_next,    "Next diagnostic" },
  },
}

return M
