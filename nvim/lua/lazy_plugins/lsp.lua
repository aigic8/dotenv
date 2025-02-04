local function config_mason()
	-- source: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
	local lspconfig = require("lspconfig")
	require("mason").setup({})
	require("mason-lspconfig").setup({
		ensure_installed = {
			"lua_ls",
			"rust_analyzer",
			"tailwindcss",
			"tsserver",
			"pyright",
			"ruff",
			"jsonls",
			"zls",
		},
		handlers = {
			function(server_name)
				lspconfig[server_name].setup({})
			end,
		},
	})
end

local function config_nvim_cmp()
	local cmp = require("cmp")

	cmp.setup({
		sources = {
			{ name = "nvim_lsp" },
		},
		mapping = {
			["<CR>"] = cmp.mapping.confirm({ select = false }),
			["<Up>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
			["<Down>"] = cmp.mapping.select_next_item({ behavior = "select" }),
			["<C-Space>"] = cmp.mapping(function()
				cmp.complete()
			end),
		},
	})
end

local function config_lsp_zero()
	local lsp_zero = require("lsp-zero")

	lsp_zero.preset("recommended")

	lsp_zero.on_attach(function(_, bufnr)
		local opts = { buffer = bufnr, remap = false }
		local buf = vim.lsp.buf
		local builtin = require("telescope.builtin")

		lsp_zero.default_keymaps({ buffer = bufnr })
		vim.keymap.set("n", "gd", buf.definition, opts)
		vim.keymap.set("n", "<leader>r", buf.rename, opts)
		vim.keymap.set("n", "<leader>c", buf.references, opts)
		vim.keymap.set("n", "<leader>o", function()
			builtin.lsp_document_symbols({ symbols = { "function", "method" } })
		end)
	end)

	config_mason()
	config_nvim_cmp()
end

return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"nvim-treesitter/nvim-treesitter",
		},
		config = config_lsp_zero,
	},
}
