local function conform_config()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			go = { "goimports", "gofmt" },
			markdown = { "prettier" },
			javascript = { "prettier" },
			json = { "prettier" },
			typescript = { "biome" },
			tex = { "tex-fmt" },
			python = { "ruff_organize_imports", "ruff_format" },
		},

		formatters = {
			mdformat = {
				append_args = { "--wrap", "80" },
			},
			prettier = {
				append_args = { "--no-semi", "--single-quote", "--trailing-comma", "all", "--prose-wrap", "always" },
			},
		},

		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	})

	vim.keymap.set("n", "<leader>f", function()
		require("conform").format({ async = true, lsp_fallback = true })
	end, { desc = "Format file" })
end

local function setup_lsps()
	-- 	-- source: https://xnacly.me/posts/2025/neovim-lsp-changes/
	local lsps = {
		{ "gopls", { filetypes = { "go" }, cmd = { "gopls" } } },
		{
			"python",
			{
				filetypes = { "python" },
				cmd = { "basedpyright-langserver", "--stdio" },
				root_markers = {
					"pyrightconfig.json",
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
					".git",
				},
			},
		},
		{
			"lua",
			{
				filetypes = { "lua" },
				cmd = { "lua-language-server" },
				settings = {
					-- TODO: temporary fix, based on the issue: https://github.com/folke/lazydev.nvim/issues/136
					-- for LazyDev plugin
					Lua = {
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
					},
				},
			},
		},
		{ "tex", { filetypes = { "tex" }, cmd = { "texlab" } } },
		{ "rust", { filetypes = { "rust" }, cmd = { "rust-analyzer" }, root_dir = vim.fs.root(0, { "Cargo.toml" }) } },
		{ "json", { filetypes = { "json" }, cmd = { "vscode-json-language-server", "--stdio" } } },
		{
			"typescript",
			{
				filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
				cmd = { "typescript-language-server", "--stdio" },
				root_dir = vim.fs.root(0, { "package.json", ".git" }),
			},
		},
	}

	for _, lsp in ipairs(lsps) do
		local name, config = lsp[1], lsp[2] or {}
		vim.lsp.config[name] = config
		vim.lsp.enable(name)
	end

	vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})

	vim.diagnostic.config({
		virtual_text = {
			severity = {
				max = vim.diagnostic.severity.WARN,
			},
		},
	})
end

local function mason_config()
	require("mason").setup({})
	setup_lsps()
end

local function nvim_lint_config()
	require("lint").linters_by_ft = {}

	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		callback = function()
			require("lint").try_lint()
			require("lint").try_lint("cspell")
		end,
	})
end

local function trouble_config()
	local trouble = require("trouble")
	trouble.setup({})

	vim.keymap.set("n", "<leader>ml", function()
		require("trouble").toggle({
			mode = "diagnostics",
			filter = { severity = vim.diagnostic.severity.ERROR },
		})
	end, {})
end

local function lazydev_config()
	require("lazydev").setup({})
end

return {
	{ "mason-org/mason.nvim", config = mason_config },
	{ "folke/lazydev.nvim", ft = "lua", config = lazydev_config },
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		opts = { keymap = { preset = "enter", fuzzy = { implementation = "prefer_rust_with_warning" } } },
		default = { "lazydev", "lsp", "path", "snippets", "buffer" },
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
		},
	},

	{
		"stevearc/conform.nvim",
		config = conform_config,
	},
	{ "lervag/vimtex", tag = "v2.17", lazy = false },
	{ "mfussenegger/nvim-lint", config = nvim_lint_config },
	{ "folke/trouble.nvim", config = trouble_config },
}
