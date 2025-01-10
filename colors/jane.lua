-- Set the global theme background
vim.o.background = "light" -- Set to "light" for a light theme
vim.cmd("highlight clear") -- Clear existing highlights to avoid conflicts
vim.cmd("syntax reset") -- Reset syntax highlighting

local colors = {
	background = "#ffffff", -- White background (light theme)
	foreground = "#000000", -- Black for default text
	dark_blue = "#0014a1", -- For normal text
	blue = "#0000ff", -- Keywords and functions
	green = "#00CC77", -- Types
	purple = "#8700af", -- If/Else keywords
	brown = "#a31515", -- Strings
	bold_black = "#000000", -- Bold keywords
	gray = "#bcbcbc", -- Comments and line numbers
	red = "#e50101", -- Errors
	goldenyellow = "#775c24", -- Warnings
	seagreen = "#0b8658", -- For types
}

-- Helper function for setting highlights
local function highlight(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

-- Editor UI
highlight("Normal", { fg = colors.dark_blue, bg = colors.background }) -- Default text to dark blue
highlight("NormalNC", { fg = colors.dark_blue, bg = colors.background }) -- Non-current windows text
highlight("CursorLine", { bg = "#f7f7f7" }) -- Current line
highlight("LineNr", { fg = colors.gray }) -- Line numbers
highlight("CursorLineNr", { fg = colors.blue, bold = true }) -- Highlighted line number
highlight("Visual", { bg = "#eaeaea" }) -- Visual selection
highlight("Whitespace", { fg = "#dcdcdc" }) -- Non-visible characters

-- Syntax Highlighting
highlight("Comment", { fg = colors.gray, italic = true }) -- Comments
highlight("Keyword", { fg = colors.blue, bold = false }) -- Keywords (e.g., `for`, `while`)
highlight("Conditional", { fg = colors.purple, bold = false }) -- If/Else keywords
highlight("Function", { fg = colors.blue, bold = false }) -- Functions
highlight("Identifier", { fg = colors.foreground }) -- Variables and identifiers
highlight("String", { fg = colors.brown }) -- Strings
highlight("Type", { fg = colors.goldenyellow, bold = false }) -- Types (e.g., `int`, `float`)
highlight("Constant", { fg = colors.goldenyellow }) -- Constants
highlight("Number", { fg = colors.goldenyellow }) -- Numbers
highlight("Boolean", { fg = colors.red }) -- Boolean values

-- UI Components
highlight("Pmenu", { bg = "#f9f9f9", fg = colors.foreground }) -- Popup menu
highlight("PmenuSel", { bg = colors.blue, fg = colors.background }) -- Selected menu item
highlight("StatusLine", { bg = "#f2f2f2", fg = colors.foreground }) -- Status line
highlight("StatusLineNC", { bg = "#e6e6e6", fg = colors.gray }) -- Inactive status line

-- Diagnostics and Errors
highlight("ErrorMsg", { fg = colors.red, bold = true }) -- Errors
highlight("WarningMsg", { fg = colors.goldenyellow }) -- Warnings
highlight("Search", { bg = colors.goldenyellow, fg = colors.background }) -- Search matches
highlight("IncSearch", { bg = colors.red, fg = colors.background }) -- Incremental search

-- Special Syntax
highlight("Special", { fg = colors.red }) -- Special symbols
highlight("Delimiter", { fg = colors.foreground }) -- Delimiters
highlight("Title", { fg = colors.blue, bold = true }) -- Titles
highlight("Directory", { fg = colors.blue }) -- Directory names
highlight("MoreMsg", { fg = colors.green }) -- Success messages
highlight("Question", { fg = colors.blue }) -- Prompts

-- Treesitter Groups
highlight("@operator", { fg = colors.red }) -- Operators (`+`, `-`, `=`...)
highlight("@punctuation", { fg = colors.red }) -- Punctuation
highlight("@variable", { fg = colors.dark_blue }) -- Variables
highlight("@field", { fg = colors.dark_blue }) -- Object fields
highlight("@property", { fg = colors.red }) -- Properties
highlight("@function.call", { fg = colors.blue, bold = false }) -- Function calls
highlight("@constant", { fg = colors.red }) -- Constants
highlight("@string", { fg = colors.brown }) -- Strings
highlight("@number", { fg = colors.red }) -- Numbers
highlight("@boolean", { fg = colors.red }) -- Booleans
highlight("@conditional", { fg = colors.purple, bold = false }) -- If/Else Keywords
highlight("@type", { fg = colors.goldenyellow }) -- Types
highlight("@function", { fg = colors.blue, bold = false }) -- Functions
highlight("@method", { fg = colors.blue, bold = false }) -- Methods
highlight("@namespace", { fg = colors.blue }) -- Namespaces
highlight("@class", { fg = colors.green, bold = false }) -- Classes
highlight("@interface", { fg = colors.green, bold = false }) -- Interfaces
highlight("@enum", { fg = colors.green, bold = false }) -- Enums
highlight("@type.parameter", { fg = colors.green }) -- Type parameters
highlight("@variable.builtin", { fg = colors.purple }) -- Built-in variables
highlight("@parameter", { fg = colors.green }) -- Parameters
highlight("@text.literal", { fg = colors.brown }) -- Literal text
