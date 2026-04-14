-- GLOBAL VARS ---------------------------
-- set line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- set tab size
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.smartindent = true

-- activate mouse
vim.opt.mouse = "a"

-- disable highlighting results of previous search
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.opt.updatetime = 50

-- BINDINGS ------------------------------
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- copy to system clipboard
vim.keymap.set({ "n", "x" }, "cp", '"+y')

-- paste from system clipboard
vim.keymap.set({ "n", "x" }, "cv", '"+p')

-- x in normal mode does not copy to default neovim clipboard
vim.keymap.set({ "n", "x" }, "x", '"_x')

-- go to definition
vim.keymap.set("n", "<leader>gd", function()
	vim.lsp.buf.definition()
end, { desc = "Go to definition" })

-- moving a whole selection up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- replace string without loosing your current vim clipboard
vim.keymap.set("x", "<leader>p", '"_dP')

-- replacing the current world
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- making file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { silent = true })

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
