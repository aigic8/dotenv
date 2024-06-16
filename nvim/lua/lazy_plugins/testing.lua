-- copied from https://github.com/nvim-neotest/neotest-go?tab=readme-ov-file#installation
local function neotest_config()
	-- get neotest namespace (api call creates or returns namespace)
	local neotest_ns = vim.api.nvim_create_namespace("neotest")
	vim.diagnostic.config({
		virtual_text = {
			format = function(diagnostic)
				local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
				return message
			end,
		},
	}, neotest_ns)

	neotest = require("neotest")
	neotest.setup({
		-- your neotest config here
		adapters = {
			require("neotest-go"),
			require("neotest-rust"),
		},
	})

	vim.keymap.set("n", "<leader>tt", neotest.summary.toggle, { silent = true })
	vim.keymap.set("n", "<leader>tr", neotest.run.run, { silent = true })
	vim.keymap.set("n", "<leader>tf", function()
		neotest.run.run(vim.fn.expand("%"))
	end, { silent = true })
	vim.keymap.set("n", "<leader>ts", function()
		neotest.run.run({ suite = true })
	end, { silent = true })
	vim.keymap.set("n", "<leader>to", neotest.output_panel.toggle, { silent = true })
end

return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- adapters
			"nvim-neotest/neotest-go",
			"rouge8/neotest-rust",
		},
		config = neotest_config,
	},
}
