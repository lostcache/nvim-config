local colorscheme = {
	bg = "#1a1b26", -- Dark background
	fg = "#c0caf5", -- Light foreground
	blue = "#7aa2f7", -- Primary blue
	cyan = "#7dcfff", -- Cyan accent
	magenta = "#bb9af7", -- Magenta accent
	green = "#9ece6a", -- Green for strings
	orange = "#ff9e64", -- Orange for keywords
	red = "#f7768e", -- Red for errors
	comment = "#565f89", -- Subtle comment color
}

-- Function to set the colorscheme highlights
local function set_highlights()
	local set_hl = vim.api.nvim_set_hl

	-- Editor UI
	set_hl(0, "Normal", { fg = colorscheme.fg, bg = colorscheme.bg })
	set_hl(0, "CursorLine", { bg = "#1f2335" })
	set_hl(0, "LineNr", { fg = colorscheme.comment })
	set_hl(0, "CursorLineNr", { fg = colorscheme.fg })
	set_hl(0, "Comment", { fg = colorscheme.comment, italic = true })

	-- Syntax highlighting
	set_hl(0, "Keyword", { fg = colorscheme.orange, bold = true })
	set_hl(0, "Function", { fg = colorscheme.blue })
	set_hl(0, "String", { fg = colorscheme.green })
	set_hl(0, "Type", { fg = colorscheme.cyan })
	set_hl(0, "Constant", { fg = colorscheme.magenta })
	set_hl(0, "Error", { fg = colorscheme.red, bold = true })

	-- Additional UI elements
	set_hl(0, "Pmenu", { bg = "#1f2335", fg = colorscheme.fg })
	set_hl(0, "PmenuSel", { bg = colorscheme.blue, fg = colorscheme.bg })
end

-- Apply the highlights
set_highlights()

-- Return the colorscheme for further customization if needed
return colorscheme
