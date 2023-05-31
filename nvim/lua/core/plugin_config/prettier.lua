
vim.api.nvim_create_autocmd({'BufWritePre'}, {
	pattern = {'*.ts', '*.tsx', '*.js', '*.jsx', '*.html', '*.css'},
	command = [[silent PrettierAsync]]
})
