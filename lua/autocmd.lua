local vim = vim

-- Create helper functions for autocommands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- [[ Formatter ]]
-- Auto-format on save
local formatter_group = augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = formatter_group,
	command = ":FormatWriteLock",
})

-- [[ LuaSnip Autocmds ]]
-- Create autocommands for Copilot-LuaSnip integration
autocmd("User", {
	pattern = { "LuasnipInsertNodeEnter", "LuasnipInsertNodeLeave" },
	callback = function()
		local copilot_enabled = not require("luasnip").expand_or_locally_jumpable()
		vim.b.copilot_suggestion_auto_trigger = copilot_enabled
		vim.b.copilot_suggestion_hidden = not copilot_enabled
	end,
})

-- [[ Terminal settings ]]
-- Auto-enter insert mode when opening terminal
autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.cmd("startinsert")
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})

-- [[ File type specific settings ]]
-- Adjust settings based on file type
autocmd("FileType", {
	pattern = { "lua", "markdown", "text", "json" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
	end,
})
