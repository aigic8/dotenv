local function harpoon_config()
	local mark = require("harpoon.mark")
	local ui = require("harpoon.ui")

	vim.keymap.set("n", "<leader>a", mark.add_file)
	vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
	vim.keymap.set("n", "<C-n>", ui.nav_next)
end

local function vim_fugitive_config()
	vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
end

local function telescope_config()
	local builtin = require("telescope.builtin")

	vim.keymap.set("n", "<leader>p", builtin.find_files, {})
	vim.keymap.set("n", "<C-p>", builtin.git_files, {})
	vim.keymap.set("n", "<leader>gg", function()
		builtin.grep_string({ search = vim.fn.input("Grep >") })
	end)
end

local function vscode_theme_config()
	vim.cmd.colorscheme("vscode")
	vim.o.background = "dark"
end

local function treesitter_config()
	local configs = require("nvim-treesitter.configs")

	configs.setup({
		ensure_installed = { "lua", "rust", "go", "typescript", "javascript", "sql", "json", "yaml", "toml" },
		sync_install = false,
		ignore_install = {},
		highlight = {
			enable = true,
			disable = {},
			additional_vim_regex_highlighting = false,
		},
	})
end

local function workspaces_config()
	local workspaces = require("workspaces")
	local telescope = require("telescope")
	telescope.load_extension("workspaces")
	workspaces.setup({
		hooks = {
			open = "Telescope find_files",
		},
	})
	vim.keymap.set("n", "<leader>wa", function()
		workspaces.add(vim.loop.cwd(), vim.fn.input("name: "))
	end)
	vim.keymap.set("n", "<leader>wd", function()
		workspaces.remove(vim.fn.input("name: "))
	end)
	vim.keymap.set("n", "<leader>wl", ":Telescope workspaces<CR>")
end

local function git_signs_config()
	require("gitsigns").setup()
end

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = telescope_config,
		tag = "0.1.6",
	},
	{ "theprimeagen/harpoon", dependencies = { "nvim-lua/plenary.nvim" }, config = harpoon_config },
	{ "tpope/vim-fugitive", config = vim_fugitive_config },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = treesitter_config },
	{ "mofiqul/vscode.nvim", config = vscode_theme_config },
	{ "natecraddock/workspaces.nvim", dependencies = { "nvim-telescope/telescope.nvim" }, config = workspaces_config },
	{ "lewis6991/gitsigns.nvim", config = git_signs_config },
	{ "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
}
