
-- set leader key as space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- set tab size
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- set numbers
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = 'a'

-- disable highlighting results of previous search
vim.opt.hlsearch = false

require('core.keymaps')
require('core.plugins')
require('core.plugin_config')
