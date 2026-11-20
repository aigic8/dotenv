local function conform_config()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			go = { "goimports", "gofmt" },
			markdown = { "prettier" },
			javascript = { "oxfmt" },
			css = { "oxfmt" },
			json = { "oxfmt" },
			typescript = { "oxfmt" },
			tex = { "tex-fmt" },
			python = { "ruff_organize_imports", "ruff_format" },
			sql = { "sqruff" },
			xml = { "xmlformatter" },
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
	local function switch_source_header(bufnr, client)
		local method_name = "textDocument/switchSourceHeader"
		---@diagnostic disable-next-line:param-type-mismatch
		if not client or not client:supports_method(method_name) then
			return vim.notify(
				("method %s is not supported by any servers active on the current buffer"):format(method_name)
			)
		end
		local params = vim.lsp.util.make_text_document_params(bufnr)
		---@diagnostic disable-next-line:param-type-mismatch
		client:request(method_name, params, function(err, result)
			if err then
				error(tostring(err))
			end
			if not result then
				vim.notify("corresponding file cannot be determined")
				return
			end
			vim.cmd.edit(vim.uri_to_fname(result))
		end, bufnr)
	end

	local function symbol_info(bufnr, client)
		local method_name = "textDocument/symbolInfo"
		---@diagnostic disable-next-line:param-type-mismatch
		if not client or not client:supports_method(method_name) then
			return vim.notify("Clangd client not found", vim.log.levels.ERROR)
		end
		local win = vim.api.nvim_get_current_win()
		local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
		---@diagnostic disable-next-line:param-type-mismatch
		client:request(method_name, params, function(err, res)
			if err or #res == 0 then
				-- Clangd always returns an error, there is no reason to parse it
				return
			end
			local container = string.format("container: %s", res[1].containerName) ---@type string
			local name = string.format("name: %s", res[1].name) ---@type string
			vim.lsp.util.open_floating_preview({ name, container }, "", {
				height = 2,
				width = math.max(string.len(name), string.len(container)),
				focusable = false,
				focus = false,
				title = "Symbol Info",
			})
		end, bufnr)
	end

	-- 	-- source: https://xnacly.me/posts/2025/neovim-lsp-changes/
	local lsps = {
		{
			"cmake",
			{
				cmd = { "neocmakelsp", "stdio" },
				filetypes = { "cmake" },
				root_markers = { ".neocmake.toml", ".git", "build", "cmake" },
			},
		},
		{
			"terrafrom",
			{
				cmd = { "terraform-ls", "serve" },
				filetypes = { "terraform", "terraform-vars" },
				root_markers = { ".terraform", ".git" },
				capabilities = {
					experimental = {
						showReferencesCommandId = "client.showReferences",
					},
				},
				on_attach = function(_, bufnr)
					vim.lsp.codelens.enable(true, { bufnr = bufnr })
				end,
			},
		},
		{
			"yaml",
			{
				cmd = function(dispatchers, config)
					local cmd = "yaml-language-server"
					if (config or {}).root_dir then
						local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
						if vim.fn.executable(local_cmd) == 1 then
							cmd = local_cmd
						end
					end
					return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
				end,
				filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
				root_markers = { ".git" },
				settings = {
					redhat = { telemetry = { enabled = false } },
					yaml = { format = { enable = true } },
				},
				on_init = function(client)
					client.server_capabilities.documentFormattingProvider = true
				end,
			},
		},
		{ "nix", { cmd = { "nil" }, filetypes = { "nix" }, root_markers = { ".git", "flake.nix" } } },
		{ "gopls", { filetypes = { "go" }, cmd = { "gopls" } } },
		{
			"cpp",
			{
				cmd = { "clangd" },
				filetypes = { "c", "c.doxygen", "cpp", "cpp.doxygen", "objc", "objcpp", "cuda" },
				root_markers = {
					".clangd",
					".clang-tidy",
					".clang-format",
					"compile_commands.json",
					"compile_flags.txt",
					"configure.ac", -- AutoTools
					".git",
				},
				get_language_id = function(_, ftype)
					local t = { objc = "objective-c", objcpp = "objective-cpp", cuda = "cuda-cpp" }
					return t[ftype] or ftype
				end,
				capabilities = {
					textDocument = {
						completion = {
							editsNearCursor = true,
						},
					},
					offsetEncoding = { "utf-8", "utf-16" },
				},
				---@param init_result ClangdInitializeResult
				on_init = function(client, init_result)
					if init_result.offsetEncoding then
						client.offset_encoding = init_result.offsetEncoding
					end
				end,
				on_attach = function(client, bufnr)
					vim.api.nvim_buf_create_user_command(bufnr, "LspClangdSwitchSourceHeader", function()
						switch_source_header(bufnr, client)
					end, { desc = "Switch between source/header" })

					vim.api.nvim_buf_create_user_command(bufnr, "LspClangdShowSymbolInfo", function()
						symbol_info(bufnr, client)
					end, { desc = "Show symbol info" })
				end,
			},
		},
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
		{
			"xml",
			{
				cmd = { "lemminx" },
				filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
				single_file_support = true,
			},
		},
		{ "tex", { filetypes = { "tex" }, cmd = { "texlab" } } },
		{ "rust", { filetypes = { "rust" }, cmd = { "rust-analyzer" }, root_dir = vim.fs.root(0, { "Cargo.toml" }) } },
		{ "json", { filetypes = { "json", "jsonc" }, cmd = { "vscode-json-language-server", "--stdio" } } },
		{ "css", { filetypes = { "css" }, cmd = { "vscode-css-language-server", "--stdio" } } },
		{ "css-vars", { filetypes = { "css" }, cmd = { "css-variables-language-server", "--stdio" } } },
		{
			"typescript",
			{
				filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
				cmd = { "typescript-language-server", "--stdio" },
				root_dir = vim.fs.root(0, { "package.json", ".git" }),
			},
		},
		{
			"html",
			{
				cmd = { "emmet-language-server", "--stdio" },
				filetypes = {
					"astro",
					"css",
					"eruby",
					"html",
					"htmlangular",
					"htmldjango",
					"javascriptreact",
					"less",
					"sass",
					"scss",
					"svelte",
					"typescriptreact",
					"vue",
				},
			},
		},
		{
			"asm",
			{
				cmd = { "asm-lsp" },
				filetypes = { "asm" },
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
	require("lint").linters_by_ft = {
		sql = { "sqruff" },
		typescript = { "oxlint" },
		javascript = { "oxlint" },
		json = { "biomejs" },
	}

	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		callback = function()
			require("lint").try_lint()
			require("lint").try_lint("cspell")
		end,
	})
end

local function minuet_config()
	require("minuet").setup({
		provider = "openai_compatible",
		request_timeout = 2.5,
		throttle = 1500, -- Increase to reduce costs and avoid rate limits
		debounce = 600, -- Increase to reduce costs and avoid rate limits
		provider_options = {
			openai_compatible = {
				transform = {
					function(data)
						local uuid = vim.fn.system({ "uuidgen" }):gsub("%s+", "")
						data.headers["x-opencode-session"] = "minuet-" .. uuid
						data.headers["User-Agent"] = "minuet-ai"
						return data
					end,
				},
				api_key = "OPENCODE_API_KEY",
				end_point = "https://opencode.ai/zen/go/v1/chat/completions",
				model = "glm-5.3-flash",
				name = "Opencode",
				optional = {
					max_tokens = 56,
					top_p = 0.9,
					-- disable thinking to avoid first token latency
					thinking = { type = "disabled" },
				},
			},
		},
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

local function markview_config()
	require("markview").setup({ preview = { enable = false } })
	vim.api.nvim_set_keymap(
		"n",
		"<leader>mp",
		"<CMD>Markview toggle<CR>",
		{ desc = "Toggles `markview` previews in buffer." }
	)
end

return {
	{ "mason-org/mason.nvim", config = mason_config },
	{ "folke/lazydev.nvim", ft = "lua", config = lazydev_config },
	{
		"saghen/blink.compat",
		version = "2.*",
		opts = {},
	},
	{
		"allaman/emoji.nvim",
		dependencies = { "saghen/blink.compat" },
		opts = { enable_cmp_integration = true },
	},

	{
		"milanglacier/minuet-ai.nvim",
		config = minuet_config,
		dependencies = { "saghen/blink.cmp" },
	},

	{
		"saghen/blink.cmp",

		dependencies = { "rafamadriz/friendly-snippets", "allaman/emoji.nvim" },
		version = "1.*",
		opts = function()
			return {
				keymap = {
					preset = "enter",
					fuzzy = { implementation = "prefer_rust_with_warning" },
					["<A-y>"] = {
						function(cmp)
							cmp.show({ providers = { "minuet" } })
						end,
					},
				},
				completion = { trigger = { prefetch_on_insert = false } },
				sources = {
					default = { "lazydev", "lsp", "path", "emoji", "snippets", "minuet", "buffer" },
					providers = {
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							score_offset = 100,
						},
						emoji = {
							name = "emoji",
							module = "blink.compat.source",
							score_offset = 15,
						},
						minuet = {
							name = "minuet",
							module = "minuet.blink",
							async = true,
							-- Should match minuet.config.request_timeout * 1000,
							-- since minuet.config.request_timeout is in seconds
							timeout_ms = 3000,
							score_offset = 50, -- Gives minuet higher priority among suggestions
						},
					},
				},
			}
		end,
	},

	{
		"stevearc/conform.nvim",
		config = conform_config,
	},
	{ "lervag/vimtex", tag = "v2.17", lazy = false },
	{ "mfussenegger/nvim-lint", config = nvim_lint_config },
	{ "folke/trouble.nvim", config = trouble_config },
	{ "OXY2DEV/markview.nvim", lazy = false, config = markview_config },
}
