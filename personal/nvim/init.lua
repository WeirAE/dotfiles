-- =============================================================================
-- init.lua — Neovim entry point
-- Bootstraps NvChad and then loads personal config from lua/custom/
-- =============================================================================

-- ---------------------------------------------------------------------------
-- Bootstrap lazy.nvim (required by NvChad)
-- ---------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ---------------------------------------------------------------------------
-- Bootstrap NvChad (clones into stdpath("data")/nvchad if absent)
-- ---------------------------------------------------------------------------
local nvchad_path = vim.fn.stdpath("data") .. "/nvchad"
if not vim.loop.fs_stat(nvchad_path) then
  vim.notify("Bootstrapping NvChad…", vim.log.levels.INFO)
  vim.fn.system({
    "git", "clone", "--depth=1",
    "https://github.com/NvChad/NvChad.git",
    nvchad_path,
  })
end
vim.opt.rtp:prepend(nvchad_path)

-- ---------------------------------------------------------------------------
-- Load NvChad core (sets up lazy, themes, statusline, etc.)
-- ---------------------------------------------------------------------------
require("nvchad")

-- ---------------------------------------------------------------------------
-- Personal overrides are in lua/custom/ (tracked in dotfiles repo)
-- NvChad reads this directory automatically for chadrc.lua
-- ---------------------------------------------------------------------------
