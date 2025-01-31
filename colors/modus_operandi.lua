local M = {}

function M.setup()
	-- Define colors
	local colors = {
		bg = "#E8E5E1", -- Warm, muted greyish background
		fg = "#000000", -- Black text for normal content
		green = "#2E8B57", -- Sea Green for types
		violet = "#8A2BE2", -- Blue Violet for keywords
		brown = "#8B4513", -- Saddle Brown for strings
		red = "#DC143C", -- Crimson for comments
		blue = "#0000FF", -- Blue for functions
		seagreen = "#20B2AA", -- Light Sea Green for special keywords
		golden_yellow = "#C9A400", -- Muted golden yellow for function parameters
		orange = "#FF8C00", -- Dark Orange
		soft_pink = "#D85A91", -- Less intense pink for visual selection
		search_yellow = "#FFFF00", -- Bright Yellow for current search match
		search_green = "#00FF00", -- Bright Green for all search matches
		line_nr_bg = "#D6D1CA", -- Slightly darker background for line numbers
		punctuation = "#303030", -- Darker grey for punctuation to be visible
	}

	-- Set up highlight groups
	local highlight_groups = {
		-- Base colors
		Normal = { fg = colors.fg, bg = colors.bg },

		-- Treesitter groups
		["@type"] = { fg = colors.green },
		["@keyword"] = { fg = colors.violet },
		["@string"] = { fg = colors.brown },
		["@comment"] = { fg = colors.red },
		["@function"] = { fg = colors.blue },
		["@method"] = { fg = colors.blue },
		["@method.call"] = { fg = colors.blue },
		["@variable"] = { fg = colors.fg },
		["@keyword.special"] = { fg = colors.seagreen },
		["@parameter"] = { fg = colors.golden_yellow }, -- Softer golden yellow
		["@lsp.type.parameter"] = { fg = colors.golden_yellow }, -- Softer golden yellow
		["@operator"] = { fg = colors.fg },
		["@punctuation.delimiter"] = { fg = colors.punctuation },
		["@punctuation.bracket"] = { fg = colors.punctuation },
		["@punctuation.special"] = { fg = colors.punctuation },

		-- Additional common groups
		Identifier = { fg = colors.fg },
		Statement = { fg = colors.violet },
		PreProc = { fg = colors.violet },
		Type = { fg = colors.green },
		Special = { fg = colors.seagreen },
		Constant = { fg = colors.blue },
		Comment = { fg = colors.red },
		String = { fg = colors.brown },
		Operator = { fg = colors.fg },
		SpecialKey = { fg = colors.fg },

		-- Visual selection and search highlights
		Visual = { bg = colors.soft_pink },
		Search = { bg = colors.search_yellow },
		IncSearch = { bg = colors.search_yellow },
		CurSearch = { bg = colors.search_yellow },
		Substitute = { bg = colors.search_green },

		-- Line numbers
		LineNr = { fg = colors.fg, bg = colors.line_nr_bg },
	}

	-- Set highlight groups
	for group, settings in pairs(highlight_groups) do
		vim.api.nvim_set_hl(0, group, settings)
	end
end

M.setup()

return M
