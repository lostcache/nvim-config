local M = {}

local vim = vim

-- Function to show diagnostics in a floating window
M.show_diagnostics_popup = function()
	local opts = {
		focusable = false,
		close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
		border = "rounded",
		source = "always", -- Show source in diagnostics popup
		prefix = "",
	}
	vim.diagnostic.open_float(nil, opts)
end

return M
