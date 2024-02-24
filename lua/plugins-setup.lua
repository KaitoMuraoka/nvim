local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Autocommand that reloads neovim whenever you save this file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local status, packer = pcall(require, "packer")
if not status then
  return 
end

return packer.startup(function(use)
  use("wbthomason/packer.nvim")
  use("nvim-lua/plenary.nvim") -- lua functions that many plugins use
  use("rebelot/kanagawa.nvim") -- kanagawa colorscheme
  use("szw/vim-maximizer")
  use("tpope/vim-surround") -- essential plugins
  use("numToStr/Comment.nvim") -- commenting with gc
  use("nvim-tree/nvim-tree.lua") -- file explorer
  use("nvim-tree/nvim-web-devicons") -- icons
  use("nvim-lualine/lualine.nvim") -- statusline
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- telescope Fuzzy Finder
  use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- telescope Fuzzy Finder

  if packer_bootstrap then
    require("packer").sync()
  end
end)
