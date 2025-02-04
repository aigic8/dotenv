local function conform_config()
	require("conform").setup({
		formatters_by_ft = {
			javascript = { "prettierd" },
			go = { "goimports", "gofmt" },
			lua = { "stylua" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },
			markdown = { "prettier" },
			rust = { "rustfmt" },
			python = { "ruff_format" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	})
end

return {
	"stevearc/conform.nvim",
	config = conform_config,
}
