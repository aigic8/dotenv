require("remap")
require("settings")
local lazy = require("lazy_init")

function SW()
	vim.cmd([[
		set textwidth=80
		set formatoptions+=t
	]])
end

lazy.init()
lazy.setup()
