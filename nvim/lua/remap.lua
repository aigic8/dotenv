vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- copy to system clipboard
vim.keymap.set({ "n", "x" }, "cp", '"+y')

-- paste from system clipboard
vim.keymap.set({ "n", "x" }, "cv", '"+p')

-- x in normal mode does not copy to default neovim clipboard
vim.keymap.set({ "n", "x" }, "x", '"_x')

-- moving a whole selection up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- replace string without loosing your current vim clipboard
vim.keymap.set("x", "<leader>p", '"_dP')

-- replacing the current world
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- making file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>gr", "<cmd>!go run %<CR>", { silent = true })

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
