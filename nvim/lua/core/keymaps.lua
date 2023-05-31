-- save
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')

-- copy to system clipboard
vim.keymap.set({'n', 'x'}, 'cp', '"+y')

-- paste from system clipboard
vim.keymap.set({'n', 'x'}, 'cv', '"+p')

-- x in normal mode does not copy to default neovim clipboard
vim.keymap.set({'n', 'x'}, 'x', '"_x')

-- select all
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')
