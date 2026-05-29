-- =============================================================================
-- lua/custom/chadrc.lua — NvChad personal configuration
-- Extends NvChad defaults; loaded automatically by NvChad core.
-- =============================================================================

---@type ChadrcConfig
local M = {}

M.ui = {
  theme        = "catppuccin",
  theme_toggle = { "catppuccin", "one_light" },

  -- Statusline
  statusline = {
    theme = "default",
    separator_style = "round",
  },

  -- Tabufline
  tabufline = {
    lazyload = true,
  },
}

M.plugins = "custom.plugins"
M.mappings = "custom.mappings"

return M
