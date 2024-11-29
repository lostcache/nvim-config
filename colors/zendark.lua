local vim = vim

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end

vim.g.colors_name = "zendark"
vim.o.background = "dark" -- Set background to dark

-- Define color palette with darker background and adjusted shades
local colors = {
	bg = "#1E1E1E", -- dark grey background
	fg = "#C0C0C0", -- lighter text for better contrast
	blue = "#5B9BD5", -- softened blue for functions
	red = "#FF6347", -- warmer red for keywords and types
	brown = "#C08552", -- softened brown for strings
	pink = "#FFB6C1", -- lighter pink for highlights
	green = "#9ACD32", -- lime green for constants and numbers
}

-- Apply highlights with adjusted shades
vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
vim.api.nvim_set_hl(0, "Comment", { fg = "#6A9955", italic = true }) -- Green for comments
vim.api.nvim_set_hl(0, "Keyword", { fg = colors.red, bold = true })
vim.api.nvim_set_hl(0, "Type", { fg = colors.green, bold = true })
vim.api.nvim_set_hl(0, "String", { fg = colors.brown })
vim.api.nvim_set_hl(0, "Number", { fg = colors.green })
vim.api.nvim_set_hl(0, "Operator", { fg = colors.fg })
vim.api.nvim_set_hl(0, "Statement", { fg = colors.red, bold = true })
vim.api.nvim_set_hl(0, "Identifier", { fg = colors.blue })
vim.api.nvim_set_hl(0, "Constant", { fg = colors.green })
vim.api.nvim_set_hl(0, "PreProc", { fg = colors.pink })
vim.api.nvim_set_hl(0, "Special", { fg = colors.brown })
vim.api.nvim_set_hl(0, "Delimiter", { fg = "#808080" })
vim.api.nvim_set_hl(0, "Function", { fg = colors.blue, bold = true })
vim.api.nvim_set_hl(0, "Error", { fg = "#FF4500", bg = colors.bg, bold = true })
vim.api.nvim_set_hl(0, "Todo", { fg = "#FFFFFF", bg = "#FF4500", bold = true })
vim.api.nvim_set_hl(0, "Title", { fg = colors.red, bold = true })
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#FFFFFF", bg = colors.red })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#5A5A5A" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2E2E2E" }) -- Slightly lighter for line highlight
vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#2E2E2E" })
vim.api.nvim_set_hl(0, "Visual", { bg = colors.pink })
vim.api.nvim_set_hl(0, "Search", { fg = "#000000", bg = "#FFD700" }) -- Yellow for search highlight
vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.fg, bg = "#2E2E2E" }) -- Dark grey for active status line
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = colors.fg, bg = "#1E1E1E" }) -- Slightly darker for inactive windows
