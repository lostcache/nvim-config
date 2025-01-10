-- Solarized Light and Dark Themes in Lua for Neovim
local api = vim.api

-- Solarized Color Palette
local colors = {
	base03 = "#002b36", -- Darkest background
	base02 = "#073642", -- Darker background
	base01 = "#586e75", -- Secondary background
	base00 = "#657b83", -- Neutral text
	base0 = "#839496", -- Light text
	base1 = "#93a1a1", -- Light gray text
	base2 = "#eee8d5", -- Light background
	base3 = "#fdf6e3", -- Brighter background
	yellow = "#b58900", -- Yellow
	orange = "#cb4b16", -- Orange
	red = "#dc322f", -- Red
	magenta = "#d33682", -- Magenta
	violet = "#6c71c4", -- Violet
	blue = "#268bd2", -- Blue
	cyan = "#2aa198", -- Cyan
	green = "#859900", -- Green
	goldenyellow = "#b39400", -- Solarized golden yellow
	gray = "#93a1a1", -- Gray
	dark_blue = "#073642", -- Darker blue
	brown = "#b58900", -- Brown
	foreground = "#657b83", -- Foreground
	background = "#fdf6e3", -- Light mode background
	dark_background = "#002b36", -- Dark mode background
}

-- Solarized Light theme (Day)
local light = {
	bg = colors.background,
	fg = colors.base00, -- Fixed foreground to base00 for Light theme
	cursor = colors.base01,
	comment = colors.base01,
	keyword = colors.blue,
	func = colors.green,
	string = colors.cyan, -- Fixed string to cyan color
	type = colors.goldenyellow,
	constant = colors.goldenyellow,
	variable = colors.dark_blue,
}

-- Solarized Dark theme (Night)
local dark = {
	bg = colors.dark_background,
	fg = colors.base0, -- Fixed foreground to base0 for Dark theme
	cursor = colors.base1,
	comment = colors.base01,
	keyword = colors.blue,
	func = colors.green,
	string = colors.cyan, -- Fixed string to cyan color
	type = colors.goldenyellow,
	constant = colors.goldenyellow,
	variable = colors.base0,
}

-- Apply highlight groups based on the theme
local function apply_theme(theme)
	-- Set background mode
	vim.opt.background = theme.bg == colors.background and "light" or "dark"

	-- General UI
	api.nvim_set_hl(0, "Normal", { fg = theme.fg, bg = theme.bg }) -- Normal text uses Solarized foreground
	api.nvim_set_hl(0, "NormalNC", { fg = theme.fg, bg = theme.bg })
	api.nvim_set_hl(0, "CursorLine", { bg = theme.bg == colors.background and "#f7f7f7" or "#073642" })
	api.nvim_set_hl(0, "LineNr", { fg = colors.gray })
	api.nvim_set_hl(0, "CursorLineNr", { fg = colors.blue, bold = true })
	api.nvim_set_hl(0, "Visual", { bg = theme.bg == colors.background and "#eaeaea" or "#586e75" })
	api.nvim_set_hl(0, "Whitespace", { fg = "#dcdcdc" })

	-- Syntax Highlighting
	api.nvim_set_hl(0, "Comment", { fg = theme.comment, italic = true })
	api.nvim_set_hl(0, "Keyword", { fg = theme.keyword })
	api.nvim_set_hl(0, "Conditional", { fg = colors.violet })
	api.nvim_set_hl(0, "Function", { fg = theme.func })
	api.nvim_set_hl(0, "Identifier", { fg = theme.variable })
	api.nvim_set_hl(0, "String", { fg = theme.string }) -- String is now fixed to cyan
	api.nvim_set_hl(0, "Type", { fg = theme.type })
	api.nvim_set_hl(0, "Constant", { fg = theme.constant })
	api.nvim_set_hl(0, "Number", { fg = colors.goldenyellow })
	api.nvim_set_hl(0, "Boolean", { fg = colors.red })

	-- Treesitter Groups
	api.nvim_set_hl(0, "@operator", { fg = colors.red })
	api.nvim_set_hl(0, "@punctuation", { fg = colors.red })
	api.nvim_set_hl(0, "@variable", { fg = theme.variable })
	api.nvim_set_hl(0, "@field", { fg = theme.variable })
	api.nvim_set_hl(0, "@property", { fg = theme.fg }) -- Property now uses normal foreground color
	api.nvim_set_hl(0, "@function.call", { fg = theme.func })
	api.nvim_set_hl(0, "@constant", { fg = colors.goldenyellow })
	api.nvim_set_hl(0, "@string", { fg = theme.string })
	api.nvim_set_hl(0, "@number", { fg = colors.goldenyellow })
	api.nvim_set_hl(0, "@boolean", { fg = colors.red })
	api.nvim_set_hl(0, "@conditional", { fg = colors.violet })
	api.nvim_set_hl(0, "@type", { fg = colors.goldenyellow })
	api.nvim_set_hl(0, "@function", { fg = theme.func })
	api.nvim_set_hl(0, "@method", { fg = theme.func })
	api.nvim_set_hl(0, "@namespace", { fg = colors.blue })
	api.nvim_set_hl(0, "@class", { fg = colors.green })
	api.nvim_set_hl(0, "@interface", { fg = colors.green })
	api.nvim_set_hl(0, "@enum", { fg = colors.green })
	api.nvim_set_hl(0, "@type.parameter", { fg = colors.green })
	api.nvim_set_hl(0, "@variable.builtin", { fg = colors.violet })
	api.nvim_set_hl(0, "@parameter", { fg = colors.green })
	api.nvim_set_hl(0, "@text.literal", { fg = colors.brown })
end

-- Function to switch to Solarized Light (Day)
function SetLightTheme()
	apply_theme(light)
end

-- Function to switch to Solarized Dark (Night)
function SetDarkTheme()
	apply_theme(dark)
end
