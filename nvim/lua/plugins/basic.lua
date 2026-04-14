local function harpoon_config()
	local mark = require("harpoon.mark")
	local ui = require("harpoon.ui")

	vim.keymap.set("n", "<leader>ha", mark.add_file)
	vim.keymap.set("n", "<leader>hl", ui.toggle_quick_menu)
	vim.keymap.set("n", "<leader>hn", ui.nav_next)
end

local function telescope_config()
	local builtin = require("telescope.builtin")

	vim.keymap.set("n", "<leader>p", builtin.find_files, {})
	vim.keymap.set("n", "<C-p>", builtin.git_files, {})
	vim.keymap.set("n", "<leader>gg", function()
		builtin.grep_string({ search = vim.fn.input("Grep >") })
	end)
	vim.keymap.set("n", "<leader>o", function()
		builtin.lsp_document_symbols({ symbols = { "Function", "Method" } })
	end, {})
	vim.keymap.set("n", "<leader>q", function()
		builtin.diagnostics({ severity = vim.diagnostic.severity.ERROR })
	end, {})
end

local function treesitter_config()
	require("nvim-treesitter").install({
		"lua",
		"rust",
		"go",
		"typescript",
		"javascript",
		"sql",
		"json",
		"yaml",
		"toml",
		"http",
		"html",
		"svelte",
		"markdown",
		"css",
	})
end

local function todo_comments_config()
	require("todo-comments").setup({})
	vim.keymap.set("n", "<leader>tl", ":TodoTelescope keywords=TODO,FIXME<CR>")
end

local function vim_fugitive_config()
	vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
end

local function monokai_pro_config()
	require("monokai-pro").setup({ filter = "spectrum" }) -- classic | octagon | pro | machine | ristretto | spectrum
	vim.cmd.colorscheme("monokai-pro")
end

local function vague_config()
	vim.cmd.colorscheme("vague")
end

local function code_dark_config()
	vim.cmd.colorscheme("codedark")
end

local function kanagawa_config()
	vim.cmd.colorscheme("kanagawa-wave")
end

local function jellybeans_config()
	vim.cmd.colorscheme("jellybeans-muted")
end

local function jetbrains_config()
	vim.cmd.colorscheme("jb")
end

return {
	{ "theprimeagen/harpoon", dependencies = { "nvim-lua/plenary.nvim" }, config = harpoon_config },
	{
		"nvim-telescope/telescope.nvim",
		version = "~0.2.0*",
		config = telescope_config,
		dependencies = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
	},
	{ "nvim-treesitter/nvim-treesitter", lazy = false, config = treesitter_config, build = ":TSUpdate" },
	{ "lewis6991/gitsigns.nvim", opts = {} },
	{ "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, config = todo_comments_config },
	{ "tpope/vim-fugitive", config = vim_fugitive_config },
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = { scope = { enabled = true } } },

	-- themes
	-- { "loctvl842/monokai-pro.nvim", lazy = false, priority = 1000, config = monokai_pro_config },
	-- { "vague-theme/vague.nvim", lazy = false, priority = 1000, config = vague_config },
	-- { "tomasiser/vim-code-dark", lazy = false, priority = 1000, config = code_dark_config },
	{ "rebelot/kanagawa.nvim", lazy = false, priority = 1000, config = kanagawa_config },
	-- { "wtfox/jellybeans.nvim", lazy = false, priority = 1000, config = jellybeans_config },
	-- { "nickkadutskyi/jb.nvim", lazy = false, priority = 1000, opts = {}, config = jetbrains_config },
}
