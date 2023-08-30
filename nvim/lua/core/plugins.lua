
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

return require('packer').startup(function(use)
  use { 'wbthomason/packer.nvim' }
	use { 'ellisonleao/gruvbox.nvim' }
	use { 'nvim-tree/nvim-tree.lua' }
	use { 'nvim-tree/nvim-web-devicons' }
	use { 'nvim-lualine/lualine.nvim' }
	use { "catppuccin/nvim", as = "catppuccin" }
	use { 'nvim-telescope/telescope.nvim', tag = '0.1.1', requires = { {'nvim-lua/plenary.nvim'} } }
	use { 'prettier/vim-prettier', run = [[npm install]] }
	use { 'folke/todo-comments.nvim', requires = {{'nvim-lua/plenary.nvim'}}}
	-- use 'fatih/vim-go'
	-- use { 'neoclide/coc.nvim', branch = 'release', run = [[:CocInstall coc-go coc-tsserver coc-rust-analyzer]] }
	use {
    'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
	}

	use { "ms-jpq/coq_nvim", branch='coq', run = [[:COQdeps]] }
	-- 'numToStr/Comment.nvim' TODO
	use { 'wakatime/vim-wakatime' }
	use { 'lewis6991/gitsigns.nvim' }
	use { 'nvim-treesitter/nvim-treesitter' }
	use 'sindrets/diffview.nvim'
  -- My plugins here

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
