local function config_mason()
	-- source: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
	local lspconfig = require("lspconfig")
	require("mason").setup({})
	require("mason-lspconfig").setup({
		ensure_installed = { "lua_ls", "gopls", "rust_analyzer", "sqls", "tailwindcss", "tsserver", "pyright", "ruff" },
		handlers = {
			function(server_name)
				lspconfig[server_name].setup({})
			end,
		},
	})
end

local function config_go_format_on_save()
	-- source: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
	vim.api.nvim_create_autocmd({ "BufWritePre" }, {
		pattern = "*.go",
		callback = function()
			local params = vim.lsp.util.make_range_params()
			params.context = { only = { "source.organizeImports" } }
			-- buf_request_sync defaults to a 1000ms timeout. Depending on your
			-- machine and codebase, you may want longer. Add an additional
			-- argument after params if you find that you have to write the file
			-- twice for changes to be saved.
			-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
			local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
			for cid, res in pairs(result or {}) do
				for _, r in pairs(res.result or {}) do
					if r.edit then
						local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
						vim.lsp.util.apply_workspace_edit(r.edit, enc)
					end
				end
			end
			vim.lsp.buf.format({ async = false })
		end,
	})
end

local function config_lsp_zero()
	local lsp_zero = require("lsp-zero")

	lsp_zero.preset("recommended")

	lsp_zero.on_attach(function(_, bufnr)
		local opts = { buffer = bufnr, remap = false }
		local buf = vim.lsp.buf
		-- see :help lsp-zero-keybindings
		-- to learn the available actions

		lsp_zero.default_keymaps({ buffer = bufnr })
		vim.keymap.set("n", "gd", buf.definition, opts)
		vim.keymap.set("n", "<leader>r", buf.rename, opts)
		vim.keymap.set("n", "<leader>c", buf.references, opts)
		vim.keymap.set("n", "<C-.>", buf.signature_help, opts)
	end)

	--	lsp_zero.format_on_save({
	--		servers = {
	--			['rust_analyzer'] = { 'rust' },
	--			['tsserver'] = { 'typescript', 'javascript' },
	--			['ruff'] = { 'python' },
	--			['gopls'] = { 'go' },
	--			['lua_ls'] = { 'lua' },
	--		}
	--	})

	config_mason()
	-- config_go_format_on_save()
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
		},
		config = config_lsp_zero,
	},
}
