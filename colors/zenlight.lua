local vim = vim

vim.o.background = "light"

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end

vim.g.colors_name = "zenlight"
vim.o.background = "light" -- Ensures background is set to light

-- Define color palette
local colors = {
	bg = "#968c74", -- light grey, paper-like background
	-- bg = "#dbdbdb", -- light grey, paper-like background
	fg = "#000000", -- default text color
	blue = "#12128c", -- functions color
	red = "#8c0a0a", -- keywords and types color
	brown = "#a52a2a", -- strings color
	pink = "#bd8e96", -- highlights color
	green = "#075707", -- constants and numbers color
}

-- Apply highlights to all specified groups
vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
vim.api.nvim_set_hl(0, "Comment", { fg = colors.green, italic = true })
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
vim.api.nvim_set_hl(0, "Error", { fg = colors.red, bg = colors.bg, bold = true })
vim.api.nvim_set_hl(0, "Todo", { fg = "#ffffff", bg = colors.red, bold = true })
vim.api.nvim_set_hl(0, "Title", { fg = colors.red, bold = true })
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ffffff", bg = colors.pink })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#5A5A5A" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#e0e0e0" })
vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#e0e0e0" })
vim.api.nvim_set_hl(0, "Visual", { bg = colors.pink })
vim.api.nvim_set_hl(0, "Search", { fg = "#000000", bg = colors.pink })
